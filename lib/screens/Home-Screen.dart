import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:polutionheatmap/Services/Location.dart';
import 'package:polutionheatmap/Services/LoginPage.dart';
import 'package:polutionheatmap/screens/profile.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.lat, this.long});
  final lat;
  final long;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  LatLng _mainLocation;
  double long;
  double lat;
  double num = 12;
  String dropdownValue;
  String list;
  String holder;
  String hold;
  List<Marker> markers = [];
  GoogleMapController controller;
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor garbage;
  BitmapDescriptor air;

  BitmapDescriptor pinLocationIcon;
  void setDropdown() {
    setState(() {
      holder = list;
    });
  }

  void getSeDropDownItem() {
    setState(() {
      hold = dropdownValue;
    });
  }

  void initState() {
    if (widget.lat == null) {
      _mainLocation = LatLng(0.0, 0.0);
    }
    _mainLocation = LatLng(widget.lat, widget.long);
    //markers.clear();
    setCustomMapPin();

    //setState(() {
    marker(BitmapDescriptor.defaultMarker, _mainLocation,
        _mainLocation.toString());
    //markers.add(Marker(
    //markerId: MarkerId("curr_loc"),

    //position: _mainLocation,
    //infoWindow: InfoWindow(title: 'Your Location'),
    //));
    //});
    super.initState();

    //getLoc();
  }

  void removeMarker() {
    //Marker marker = markers.firstWhere(
    //(marker) => marker.markerId.value == tappedPoint.toString(),
    // orElse: () => null);
    setState(() {
      //markers.remove(marker);
      markers.removeLast();
    });
  }

  void marker(BitmapDescriptor icon, LatLng pos, String st) {
    //controller.addMarker
    markers.add(Marker(
        markerId: MarkerId(pos.toString()),
        draggable: true,
        position: pos,
        icon: icon));
  }

  void setCustomMapPin() async {
    garbage = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 0.5), 'images/garbage.png');
    air = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 1.5), 'images/CO2.png');
  }

  _handleTap(LatLng tappedPoint) {
    setState(() {
      if (holder == 'Land Pollution') {
        marker(garbage, tappedPoint, tappedPoint.toString());
      } else if (holder == 'Air Pollution') {
        marker(air, tappedPoint, tappedPoint.toString());
      }
    });
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.teal,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.blue.shade300,
            title: Text(
              'Location',
            ),
          ),
          body: Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _mainLocation,
                  zoom: 15,
                ),
                markers: Set.from(markers),
                onTap: _handleTap,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(130.0, 3.0, 1.0, 3.0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.black,
                        child: IconButton(
                          // remove default padding here
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.remove),
                          color: Colors.white,
                          onPressed: () {
                            removeMarker();
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50.0, 3.0, 8.0, 100.0),
                      child: DropdownButton<String>(
                        value: list,
                        icon: CircleAvatar(
                          child: Icon(Icons.add),
                          backgroundColor: Colors.black,
                        ),
                        iconSize: 44,
                        elevation: 12,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            list = newValue;
                            setDropdown();
                            //getSeDropDownItem();
                          });
                        },
                        items: <String>['Air Pollution', 'Land Pollution']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 1.0, 2.0, 35.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    child: IconButton(
                      // remove default padding here
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.my_location),
                      color: Colors.white,
                      onPressed: () {
                        _goToStart();
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
          //HomePage(),

          drawer: Drawer(
            child: Container(
              color: Colors.teal,
              child: ListView(
                children: <Widget>[
                  DrawerHeader(
                    child: FutureBuilder(
                        future: FirebaseAuth.instance.currentUser(),
                        builder: (BuildContext context,
                            AsyncSnapshot<FirebaseUser> user) {
                          if (user.data == null) {
                            return Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                Text(
                                  ' Please LogIn',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            );
                          } else {
                            return Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  user.data.displayName.toString() + "!",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            );
                          }
                        }),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return profile();
                        }));
                      });
                    },
                    child: ListTile(
                      title: Text('Profile'),
                      leading: Icon(Icons.person),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {},
                    child: ListTile(
                      title: Text('Setting'),
                      leading: Icon(Icons.settings),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut().then((onValue) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LogInPage()),
                          (Route<dynamic> route) => false,
                        );
                      });
                    },
                    child: ListTile(
                      title: Text('SignOut'),
                      leading: Icon(Icons.trending_flat),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future<void> _goToStart() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _mainLocation, zoom: 15),
      ),
    );
  }
}
