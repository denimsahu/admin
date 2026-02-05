import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
CollectionReference Drivers = firebaseFirestore.collection("Drivers");

late BitmapDescriptor addStopMarkerIcon;
late BitmapDescriptor currentPositionIcon;