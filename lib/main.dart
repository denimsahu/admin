import 'package:admin/Home/View/Home.dart';
import 'package:admin/Home/bloc/home_bloc.dart';
import 'package:admin/Login/login/View/login.dart';
import 'package:admin/Login/login/bloc/login_bloc.dart';
import 'package:admin/Login/verifyOtp/bloc/verify_otp_bloc.dart';
import 'package:admin/NewDriver/View/AddStops.dart';
import 'package:admin/NewDriver/View/NewDriver.dart';
import 'package:admin/NewDriver/bloc/add_stops_bloc.dart';
import 'package:admin/NewDriver/bloc/create_driver_bloc.dart';
import 'package:admin/Splash/Splash.dart';
import 'package:admin/global/Variables.dart';
import 'package:admin/permission/permission.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


  void loadAddStopsMarkerIcon() async {
    addStopMarkerIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size.square(30.0),), "assets/stops-adder.png");
    currentPositionIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size.square(30.0),), "assets/mylocation.png");
  }


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  loadAddStopsMarkerIcon();
  runApp(const Administrator());
}

class Administrator extends StatelessWidget {
  const Administrator({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider(
          create: (context) => VerifyOtpBloc(),
        ),
        BlocProvider(
          create: (context) => CreateDriverBloc(),
        ),
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
        BlocProvider(
          create: (context) => AddStopsBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => SplashScreen(),
          '/driverList': (context) => permission(),
          '/login' :(context) => LoginScreen(),
          '/home' :(context) => HomeScreen(),
          '/NewDriver' :(context) => NewDriver(),
          '/addStops' :(context) => AddStops(),
        },
        initialRoute: "/",
      ),
    );
  }
}
