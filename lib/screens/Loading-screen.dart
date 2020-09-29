import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:polutionheatmap/Services/Location.dart';
import 'package:polutionheatmap/Services/LoginPage.dart';
import 'package:polutionheatmap/screens/Home-Screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen({this.loc});
  final LatLng loc;
  _LoadingScreenState createState() {
    return _LoadingScreenState();
  }
}

class _LoadingScreenState extends State<LoadingScreen> {
  double lat;
  double long;
  void initState() {
    super.initState();
    checkIfUserLogged();
  }

  Future<void> checkIfUserLogged() async {
    if (await FirebaseAuth.instance.currentUser() != null) {
      getLocation();
    } else {
      session();
    }
  }

  void getLocation() async {
    Location location = Location();
    await location.getCurrentLocation();

    lat = location.getLat();
    long = location.getLong();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return HomeScreen(
        lat: lat,
        long: long,
      );
    }));
  }

  Future<bool> session() async {
    await Future.delayed(Duration(milliseconds: 5000), () {});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return LogInPage();
    }));
    return true;
  }

  double getLat() {
    return lat;
  }

  double getLong() {
    return long;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Pollution Heat Map',
            style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          SpinKitDoubleBounce(
            color: Colors.black,
            size: 100.0,
          ),
        ],
      ),
    );
  }
}
