import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polutionheatmap/Services/Location.dart';
import 'package:polutionheatmap/Services/LoginPage.dart';
import 'package:polutionheatmap/screens/Home-Screen.dart';

class profile extends StatefulWidget {
  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  double lat, long;

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

  Future<DocumentSnapshot> getUserInfo() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    return await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .get();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.teal,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.blue.shade300,
              title: Text(
                'Profile',
              ),
            ),
            body: SafeArea(
              child: FutureBuilder(
                  future: FirebaseAuth.instance.currentUser(),
                  builder:
                      (BuildContext context, AsyncSnapshot<FirebaseUser> user) {
                    if (user.data == null) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 90,
                            ),
                          ),
                          Text(
                            'Please LogIn',
                            style: TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 20.0,
                            width: 300,
                            child: Divider(
                              color: Colors.teal.shade100,
                            ),
                          ),
                          Card(
                              color: Colors.white,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: ListTile(
                                leading: Icon(
                                  Icons.email,
                                  color: Colors.teal,
                                ),
                                title: Text(
                                  '',
                                  style: TextStyle(
                                      fontFamily: 'Source Sans Pro',
                                      fontSize: 20.0,
                                      color: Colors.teal.shade900),
                                ),
                              )),
                        ],
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 90,
                            ),
                          ),
                          Text(
                            user.data.displayName.toString() + "!",
                            style: TextStyle(
                                fontFamily: 'Pacifico',
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 20.0,
                            width: 300,
                            child: Divider(
                              color: Colors.teal.shade100,
                            ),
                          ),
                          Card(
                              color: Colors.white,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: ListTile(
                                leading: Icon(
                                  Icons.email,
                                  color: Colors.teal,
                                ),
                                title: Text(
                                  user.data.email.toString(),
                                  style: TextStyle(
                                      fontFamily: 'Source Sans Pro',
                                      fontSize: 20.0,
                                      color: Colors.teal.shade900),
                                ),
                              )),
                        ],
                      );
                    }
                    //return CircularProgressIndicator();
                  }),
            ),
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
                                    'Please LogIn',
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
                                  Text(
                                    '  ' +
                                        user.data.displayName.toString() +
                                        "!",
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
                          getLocation();
                        });
                      },
                      child: ListTile(
                        title: Text('Map'),
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
                        // _signOut();
                        FirebaseAuth.instance.signOut().then((onValue) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LogInPage()),
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
            )));
  }
}
