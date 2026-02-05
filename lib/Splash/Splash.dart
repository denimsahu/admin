import 'package:flutter/material.dart';
import 'package:admin/Login/variables.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void CurrentUser() async {
    if (firebaseAuth.currentUser == null) {
      await Future.delayed(Duration(seconds: 1));
      Navigator.popAndPushNamed(context, '/login');
    } else {
      await Future.delayed(Duration(seconds: 1));
      Navigator.popAndPushNamed(context, '/home');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          "assets/appSplash.jpeg",
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
