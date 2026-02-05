import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class permission extends StatefulWidget {
  const permission({super.key});

  @override
  State<permission> createState() => _LoginState();
}

class _LoginState extends State<permission> {
  Stream<dynamic> getdata(BuildContext context) async* {
    int i = 0;
    List<Map> DriverIdList = [];
    dynamic newmap = {};
    // List Driver_permmision_list=[];
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('Drivers');
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    for (i; i < allData.length; i++) {
      Map Driver = allData[i] as Map;
      String DriverId = Driver["Vehicle Number"];
      bool Driver_permmision = Driver['DrivingAllowed'];
      // DriverIdList.add(DriverId);
      // Driver_permmision_list.add(Driver_permmision);
      newmap = {'Name': DriverId, 'permmision': Driver_permmision};
      DriverIdList.add(newmap);
    }
    print(DriverIdList);
    yield DriverIdList;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
              iconSize: 25.0,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          title: Text('Driver Permission',style: TextStyle(color: Colors.black),),
          centerTitle: true,
          backgroundColor: Colors.lightGreen[300],
        ),
        body: StreamBuilder(
            stream: getdata(context),
            builder: (context, snapshot) {
              // print(snapshot.data!.docs);
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return listview(i: index, mac1: snapshot.data as List);
                    });
              } else {
                return Center(child: Text('Fatching the data...'));
              }
            }),
      ),
    );
  }
}

class listview extends StatefulWidget {
  List mac1 = [];
  int i;
  // bool mac2 = true;
  listview({required this.i, required this.mac1});
  // const listview({super.key});

  @override
  State<listview> createState() => _listviewState(i: i, mac1: mac1);
}

class _listviewState extends State<listview> {
  List mac1 = [];
  int i;
  _listviewState({required this.i, required this.mac1});
  CollectionReference drivercollection =
      FirebaseFirestore.instance.collection("Drivers");
  CollectionReference stops = FirebaseFirestore.instance.collection("Stops");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getData();
  }

  setdata() async {
    bool a;
    await Future.delayed(Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(mac1[i]['Name']),
      tileColor: mac1[i]['permmision']
          ? Color.fromARGB(84, 172, 255, 156)
          : Color.fromARGB(255, 255, 255, 255),
      subtitle: Text(mac1[i]['permmision'] ? 'On' : 'Off'),
      trailing: Switch(
        value: mac1[i]['permmision'],
        onChanged: (value) {
          setState(() {
            mac1[i]['permmision'] = value;
            drivercollection.doc(mac1[i]['Name'].toString()).update({
              'DrivingAllowed': mac1[i]['permmision'] as bool,
            });
            stops.doc(mac1[i]['Name'].toString()).update({
              'DrivingAllowed': mac1[i]['permmision'] as bool,
            });
            if (mac1[i]['permmision'] == false) {
              //
              bool mac3 = false;
              drivercollection.doc(mac1[i]['Name'].toString()).update({
                'IsOn': mac3,
              });
              stops.doc(mac1[i]['Name'].toString()).update({
                'IsOn': mac3,
              });
            }
          });
        },
        activeColor: Color.fromARGB(255, 93, 240, 199),
        thumbColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return Color.fromARGB(255, 93, 240, 199).withOpacity(10);
          }
          return Color.fromARGB(255, 93, 240, 199);
        }),
        focusColor: const Color.fromARGB(255, 175, 76, 76),
        trackColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return Color.fromARGB(255, 255, 0, 0).withOpacity(.48);
          }
          return Color.fromARGB(255, 93, 240, 199).withOpacity(.50);
        }),
      ),
    );
  }
}
