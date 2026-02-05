import 'dart:async';
import 'package:lottie/lottie.dart' as lottie;
import 'package:admin/Home/bloc/home_bloc.dart';
import 'package:admin/Login/variables.dart';
import 'package:admin/global/Variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription<Position> userMarkerStream;
  late GoogleMapController googleMapController;
  bool GeneratorOn = true;
  List<Marker> Markers = [];

  Stream<List<Marker>> startDriversPositionStream() async* {
    try {
      await for (QuerySnapshot<Map<String, dynamic>> snapshot
          in firebaseFirestore.collection("Drivers").snapshots()) {
        if (!GeneratorOn) {
          throw {"Drivers Generator Stopped"};
        }
        ;
        try {
          for (QueryDocumentSnapshot document in snapshot.docs) {
            String markerid = document.get("MarkerId").toString();
            String latitide = document.get("latitude").toString();
            String langitude = document.get("langitude").toString();
            if ((latitide == "0" || langitude == "0")){}
            else {
              try {
                int existingIndex = Markers.indexWhere(
                    (element) => element.markerId == MarkerId(markerid));
                if (existingIndex != -1 && document.get("IsOn")) {
                  // Driver marker already exists, update its position
                  Markers[existingIndex] = Marker(
                    icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size.square(300.0)),"assets/green-bus.png"),
                    markerId: MarkerId(markerid),
                    position:
                        LatLng(double.parse(latitide), double.parse(langitude)),
                    infoWindow: InfoWindow(
                      title: markerid,
                    ),
                    onTap: () {
                      context.read<HomeBloc>().add(HomePageAddPolylineEvent(DriverUsername: markerid));
                      googleMapController.animateCamera(CameraUpdate.newLatLngZoom((LatLng(double.parse(latitide), double.parse(langitude))), 16.0));
                    },
                  );
                } else if(existingIndex!=-1 && !document.get('IsOn') ){
                  if(!document.get('DrivingAllowed')){

                  
                   Markers[existingIndex] = Marker(
                    icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size.square(300.0)),"assets/red-bus.png"),
                    markerId: MarkerId(markerid),
                    position:
                        LatLng(double.parse(latitide), double.parse(langitude)),
                    infoWindow: InfoWindow(
                      title: markerid,
                    ),
                    onTap: () {
                      context.read<HomeBloc>().add(HomePageAddPolylineEvent(DriverUsername: markerid));
                      googleMapController.animateCamera(CameraUpdate.newLatLngZoom((LatLng(double.parse(latitide), double.parse(langitude))), 16.0));
                    },
                  );
                  }
                  else{
                    Markers[existingIndex] = Marker(
                    icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size.square(300.0)),"assets/yellow-bus.png"),
                    markerId: MarkerId(markerid),
                    position:
                        LatLng(double.parse(latitide), double.parse(langitude)),
                    infoWindow: InfoWindow(
                      title: markerid,
                    ),
                    onTap: () {
                      context.read<HomeBloc>().add(HomePageAddPolylineEvent(DriverUsername: markerid));
                      googleMapController.animateCamera(CameraUpdate.newLatLngZoom((LatLng(double.parse(latitide), double.parse(langitude))), 16.0));
                    },
                  );
                  }



                }
                else {
                  // Driver marker doesn't exist, add it to the end of the list
                  if(document.get('IsOn')){
                    
                  Markers.add(
                    Marker(
                      markerId: MarkerId(markerid),
                       icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size.square(300.0)),"assets/green-bus.png"),
                      position: LatLng(
                          double.parse(latitide), double.parse(langitude)),
                      infoWindow: InfoWindow(
                        title: markerid,
                      ),
                      onTap: () {
                        context.read<HomeBloc>().add(HomePageAddPolylineEvent(DriverUsername: markerid));
                        googleMapController.animateCamera(CameraUpdate.newLatLngZoom((LatLng(double.parse(latitide), double.parse(langitude))), 16.0));
                      },
                    ),
                  );
                  }
                   else{
                    if(!document.get('DrivingAllowed')){
                        Markers.add(
                    Marker(
                      markerId: MarkerId(markerid),
                       icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size.square(300.0)),"assets/red-bus.png"),
                      position: LatLng(
                          double.parse(latitide), double.parse(langitude)),
                      infoWindow: InfoWindow(
                        title: markerid,
                      ),
                      onTap: () {
                        context.read<HomeBloc>().add(HomePageAddPolylineEvent(DriverUsername: markerid));
                        googleMapController.animateCamera(CameraUpdate.newLatLngZoom((LatLng(double.parse(latitide), double.parse(langitude))), 16.0));
                      },
                    ),
                  );
                    }
                    else{

                    
                    
                  Markers.add(
                    Marker(
                      markerId: MarkerId(markerid),
                       icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size.square(300.0)),"assets/yellow-bus.png"),
                      position: LatLng(
                          double.parse(latitide), double.parse(langitude)),
                      infoWindow: InfoWindow(
                        title: markerid,
                      ),
                      onTap: () {
                        context.read<HomeBloc>().add(HomePageAddPolylineEvent(DriverUsername: markerid));
                        googleMapController.animateCamera(CameraUpdate.newLatLngZoom((LatLng(double.parse(latitide), double.parse(langitude))), 16.0));
                      },
                    ),
                  );
                 }
                  }


                }
              } catch (error) {
                debugPrint(
                    "Error while trying to add driver markers: ${error.toString()}");
              }
            }
          }
        } catch (e) {
          debugPrint(
              "Error while trying to start Drivers Stream ${e.toString()}");
        }
        yield Markers;
      }
    } catch (error) {
      debugPrint("error ${error.toString()}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<HomeBloc>(context).add(HomePageGetUserLocationPermissionEvent());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userMarkerStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawerDragStartBehavior: DragStartBehavior.down,
        drawerEdgeDragWidth: 40.0,
        drawer: Drawer(
          elevation: 80.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(40.0), left: Radius.zero)),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.3,
                color: Colors.lightGreen[300],
                child: lottie.Lottie.asset("assets/ProfileDrawer.json",fit: BoxFit.contain)
                ),
              ListTile(
                title: const Text('Profile'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Drivers'),
                onTap: () {
                  Navigator.popAndPushNamed(context, "/driverList");
                },
              ),
              Divider(),
              ListTile(
                title: const Text('Settings'),
                onTap: () {},
              ),
              Container(
                margin: EdgeInsets.fromLTRB((MediaQuery.of(context).size.width*0.08)/2,MediaQuery.of(context).size.height*0.4,(MediaQuery.of(context).size.width*0.08)/2,0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 174, 213, 129)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0), // Adjust the radius as needed
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 0.0, vertical: 13.0), // Adjust the horizontal padding as needed
                      ),
                    ),
                    onPressed: () async {
                      GeneratorOn = false;
                      await firebaseAuth.signOut();
                      Navigator.pop(context);
                      Navigator.popAndPushNamed(context, "/login");
                    },
                    child: Text("Logout",style: TextStyle(color: Colors.black),)),
              )
            ],
          ),
        ),
        appBar: AppBar(
          leading: Builder(builder: (context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                size: 30.0,
                color: Colors.black,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
          title: Text(
            "Home",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.lightGreen[300],
        ),
        body: Stack(
          children: [
          MultiBlocListener(
            listeners: [
              BlocListener<HomeBloc, HomeState>(
                listener: (context, state) async {
                  if(state is HomePageLoadingState){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.Message.toString())));
                }
                else if(state is HomePageGetUserLocationPermissionSuccessState){
                  context.read<HomeBloc>().add(HomePageStartUserLocationStreamEvent());
                }
                else if(state is HomePageStartUserLocationStreamState){
                  try{
                    if(userMarkerStream==null){
                      debugPrint("Should'nt be printing in any case accoording to my hit and learn method");
                    }
                  }
                  catch(error){
                    if(error.toString().contains("LateInitializationError: Field 'userMarkerStream' has not been initialized.")){
                      userMarkerStream = await Geolocator.getPositionStream(locationSettings: LocationSettings(accuracy: LocationAccuracy.best)).listen((event) async {
                        try {
                          int userIndex = Markers.indexWhere((element) => element.markerId == MarkerId("User"));
                          if (userIndex != -1) {
                            Markers[userIndex] = Marker(markerId: MarkerId("User"), position: LatLng(event.latitude, event.longitude,), icon:currentPositionIcon);
                          } else {
                            Markers.add(Marker(markerId: MarkerId("User"), position: LatLng(event.latitude, event.longitude),icon:currentPositionIcon));
                            googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(event.latitude, event.longitude), 16.0));
                          }
                        } 
                        catch (error) {
                          debugPrint("Error while trying to add user markers: ${error.toString()}");
                        }
                        },
                        onError: (Error){
                          context.read<HomeBloc>().add(HomePageErrorEvent(errorMessage: "Gps is Disabled, Please Enable it to Get Your Live Location."));

                        });
                    }
                    else{
                      debugPrint("Stream already running....");
                      debugPrint(error.toString());
                    }
                  }
                }
                },
              ),
            ],
            child: StreamBuilder<Iterable<Marker>>(
              stream: startDriversPositionStream(),
              initialData: [],
              builder: (context, snapshot) {
                
                  return BlocConsumer<HomeBloc, HomeState>(
                    listener: (context, state) {
                      if(state is HomePageErrorState){
                        ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.ErrorMessage)));
                      }
                      else if (state is HomePageAddPolylinState){
                        googleMapController.animateCamera(CameraUpdate.newLatLngZoom((state.cameraUpdateLatLang), 16.0));
                      }
                    },
                    builder: (context, state) {
                      return GoogleMap(
                        mapToolbarEnabled: false,
                        mapType: MapType.normal,
                        onMapCreated: (controller) {
                          googleMapController=controller;
                        },
                        initialCameraPosition: CameraPosition(target: LatLng(24.5469221, 73.7025429)),
                        zoomControlsEnabled: false,
                        markers: Set<Marker>.of(snapshot.data!),
                        polylines: Set.from([Polyline(polylineId: PolylineId("1"),points: state is HomePageAddPolylinState?state.route:[])]),
                      );
                    },
                  );
              },
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width*0.2,
            height:  MediaQuery.of(context).size.height*0.08,
              bottom: 30,
              right: 10,
               child: Opacity(
                opacity: 0.6,
                 child: FloatingActionButton(
                  elevation: 20.0,
                      onPressed: (){
                        int markerid=Markers.indexWhere((element) => element.markerId==MarkerId("User"));
                        if(markerid==-1){
                          context.read<HomeBloc>().add(HomePageGetUserLocationPermissionEvent());
                        }
                        else{
                          googleMapController.animateCamera(CameraUpdate.newLatLngZoom(Markers[markerid].position, 16));
                        }
                      },
                      child: Icon(Icons.gps_fixed,size: 30.0,),
                      backgroundColor: Colors.black87,
                    ),
               ),
             ),
          Positioned(
              bottom: 30.0,
              left: 20.0,
              child: Opacity(
                opacity: 0.9,
                child: Container(
                    width: 130.0,
                    height: 50.0,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 20.0,
                            backgroundColor: Colors.lightGreen[300],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25))),
                        onPressed: () {
                          Navigator.pushNamed(context, "/NewDriver");
                        },
                        child: Text(
                          "New Driver",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ))),
              ))
        ]));
  }
}
