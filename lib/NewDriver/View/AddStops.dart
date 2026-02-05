import 'package:admin/NewDriver/bloc/add_stops_bloc.dart';
import 'package:admin/global/Variables.dart';
import 'package:admin/global/Widgets/CustomBigElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;

class AddStops extends StatefulWidget {
  const AddStops({super.key});

  @override
  State<AddStops> createState() => _AddStopsState();
}

class _AddStopsState extends State<AddStops> {
  late GoogleMapController mapController;

  List<Marker> markers = [];

  Marker markerAdder({LatLng? position}) {
    return Marker(
      zIndex: 2.0,
      markerId: MarkerId("Adder"),
      position: position ?? LatLng(25.321684, 82.987289),
      draggable: true,
      icon: addStopMarkerIcon,
      onDragEnd: (value) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            TextEditingController stopName = TextEditingController();
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              title: Text('Add Stop'),
              content: TextField(
                controller: stopName,
                decoration: InputDecoration(
                  hintText: 'Enter Stop Name',
                ),
              ),
              actions: <Widget>[
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      SizedBox(width: 10),
                      TextButton(
                        onPressed: () async {
                          if (stopName.value.text == "Adder" ||
                              stopName.value.text == "User") {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(new SnackBar(
                              content: Text("Invalid Stop Name"),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              margin: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.height - 100,
                                  right: 20,
                                  left: 20),
                            ));
                          } else if (!RegExp(r'^\S.*\S$')
                              .hasMatch(stopName.value.text.toString())) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(new SnackBar(
                              content: Text(
                                  "Stop Name Can't Start/End with space or Empty"),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              margin: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.height - 100,
                                  right: 20,
                                  left: 20),
                            ));
                          } else {
                            bool invalidName = false;
                            markers.forEach((element) {
                              if (element.markerId ==
                                  MarkerId(stopName.value.text.toString())) {
                                invalidName = true;
                              }
                            });
                            if (invalidName) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(new SnackBar(
                                content: Text("Two Stops Can't Have Same Name"),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                margin: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.height -
                                        100,
                                    right: 20,
                                    left: 20),
                              ));
                            } else {
                              int markersLength=1;
                              markers.forEach((element) {
                                if (element.markerId.value != "Adder" &&
                                element.markerId.value != "User") {
                                  print(markersLength);
                                  markersLength++;
                                }
                              });
                              markers.add(Marker(
                                  markerId:
                                      MarkerId(stopName.value.text.toString()),
                                      icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size.square(30.0),), "assets/stops.png"),
                                      infoWindow: InfoWindow(title: "Stop ${markersLength} : ${stopName.value.text.toString()}"),
                                  position: value));

                              Navigator.of(context).pop();
                              context
                                  .read<AddStopsBloc>()
                                  .add(AddStopsUpdateMarkersEvent());
                            }
                          }
                        },
                        child: Text('Add'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    markers.add(markerAdder());
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> driverDetails =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return BlocListener<AddStopsBloc, AddStopsState>(
      listener: (context, state) {
        if (state is AddStopsErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error.toString())));
        } else if (state is AddStopsLoadingState) {
          if (state.Message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.Message.toString())));
          }
        } else if (state is AddStopsGotAdminPositionPermissionSuccessState) {
          context
              .read<AddStopsBloc>()
              .add(AddStopsGetAdminCurrentPositionEvent());
        }
        else if (state is AddStopsDriverCreatedSuccessfullyState){
          ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Driver Created Successfully!")));
          Navigator.of(context).popUntil((route){
            return route.settings.name == '/home';
          });
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(onPressed: (){Navigator.of(context).pop();}, icon: Icon(Icons.arrow_back, size: 25.0, color: Colors.black,)),
          title: Text("Add Stops", style: TextStyle(color: Colors.black),),
          centerTitle: true,
          backgroundColor: Colors.lightGreen[300],
        ),
        body: Stack(
          children: [
            BlocBuilder<AddStopsBloc, AddStopsState>(
              builder: (context, state) {
                if (state is AddStopsGotAdminLocationState) {
                  int userMarkerIndex = markers.indexWhere(
                      (element) => element.markerId == MarkerId("User"));
                  if (userMarkerIndex != -1) {
                    markers[userMarkerIndex] = (Marker(
                        markerId: MarkerId("User"),
                        icon: currentPositionIcon,
                        position: state.currentPosition));
                  } else {
                    markers.add(Marker(
                        markerId: MarkerId("User"),
                        icon: currentPositionIcon,
                        position: state.currentPosition));
                  }
                  markers[markers.indexWhere(
                          (element) => element.markerId == MarkerId("Adder"))] =
                      markerAdder(position: state.currentPosition);
                  mapController.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: state.currentPosition, zoom: 16.0)));
                  return GoogleMap(
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                        target: state.currentPosition, zoom: 10.0),
                    markers: Set<Marker>.of(markers),
                    zoomControlsEnabled: false,
                  );
                } else if (state is AddStopsUpdateMarkersState) {
                  debugPrint(markers.length.toString());
                  late LatLng adderPosition;
                  for (Marker element in markers) {
                    debugPrint(element.markerId.toString());
                    if (element.markerId == MarkerId("Adder")) {
                      adderPosition = element.position;
                      // break;
                    }
                  }
                  return GoogleMap(
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                    initialCameraPosition:
                        CameraPosition(target: adderPosition),
                    markers: Set<Marker>.of(markers),
                    zoomControlsEnabled: false,
                  );
                }
                return GoogleMap(
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                      target: LatLng(25.321684, 82.987289), zoom: 4.0),
                  markers: Set<Marker>.of(markers),
                  zoomControlsEnabled: false,
                );
              },
            ),
            Positioned(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.08,
              top: 30,
              right: 10,
              child: Opacity(
                opacity: 0.6,
                child: FloatingActionButton(
                  onPressed: () {
                    context
                        .read<AddStopsBloc>()
                        .add(AddStopsGetPositionPermissionEvent());
                  },
                  child: Icon(
                    Icons.gps_fixed,
                    size: 30.0,
                  ),
                  backgroundColor: Colors.black87,
                ),
              ),
            ),
            Positioned(
              bottom: 30.0,
              child: Center(child: BlocBuilder<AddStopsBloc, AddStopsState>(
                builder: (context, state) {
                  return CustomBigElevatedButton(
                      color: state is AddStopsLoadingState?Colors.lightGreen[100]:Colors.lightGreen.shade300,
                      context: context,
                      onPressed: state is AddStopsLoadingState?(){null;}:(){context.read<AddStopsBloc>().add(AddStopsAddedEvent(stopsList: markers, driverDetails: driverDetails));},
                      child: state is AddStopsLoadingState?lottie.Lottie.asset("assets/loadingDotsGreen.json"):Text("Done",style: TextStyle(fontSize: 20, color: Colors.black),)
                      );
                },
              )),
            )
          ],
        ),
      ),
    );
  }
}
