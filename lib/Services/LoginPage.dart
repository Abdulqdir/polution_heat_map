//import 'dart:html';
import 'package:polutionheatmap/Services/AppCard.dart';
import 'package:flutter/material.dart';
import 'package:polutionheatmap/Services/Location.dart';
import 'package:polutionheatmap/screens/Home-Screen.dart';
import 'package:polutionheatmap/Services/RegisterScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:polutionheatmap/screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LogInPage extends StatefulWidget {
  LogInPage({this.name});
  final name;
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  String email, password, name;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _autoValidate = false;
  String errorMsg = "";
  bool _loading = false;
  void initState() {
    name = widget.name;
    super.initState();
  }

  Future<void> signIn() async {
    final formState = formKey.currentState;
    if (formKey.currentState.validate()) {
      formState.save();

      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: email, password: password))
            .user;
        getLocation();
      } catch (error) {
        switch (error.code) {
          case "ERROR_USER_NOT_FOUND":
            {
              setState(() {
                errorMsg =
                    "There is no user with such entries. Please try again.";
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Container(
                        child: Text(errorMsg),
                      ),
                    );
                  });
            }
            break;
          case "ERROR_WRONG_PASSWORD":
            {
              setState(() {
                errorMsg = "Password doesn\'t match your email.";
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Container(
                        child: Text(errorMsg),
                      ),
                    );
                  });
            }
            break;
          default:
            {
              setState(() {
                errorMsg = "";
              });
            }
        }
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) return '*Required';
    if (!regex.hasMatch(value))
      return '*Enter a valid email';
    else
      return null;
  }

  void getLocation() async {
    Location location = Location();
    await location.getCurrentLocation();

    var lat = location.getLat();
    var long = location.getLong();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return HomeScreen(
        lat: lat,
        long: long,
      );
    }));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue.shade300,
        title: Text(
          'Pollution Heat Map',
        ),
      ),
      body: Form(
        key: formKey,
        autovalidate: _autoValidate,
        child: Container(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 60.0,
                    width: 300,
                    child: Divider(
                      color: Colors.teal,
                    ),
                  ),
                  AppCard(
                    child: Container(
                      height: 30,
                      child: Text(
                        'Sign in',
                        style: TextStyle(fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  AppCard(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Email'),
                            // ignore: missing_return
                            validator: emailValidator,
                            onSaved: (input) => email = input,
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Password'),
                            // ignore: missing_return
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'please type password';
                              }
                            },
                            onSaved: (input) => password = input,
                            obscureText: true,
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 20.0),
                            child: FlatButton(
                                color: Colors.black,
                                textColor: Colors.white,
                                onPressed: signIn,
                                child: Text('Log In')),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: FlatButton(
                                textColor: Colors.black,
                                onPressed: () {},
                                child: Text('forgot password')),
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don't have account??"),
                      FlatButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Register();
                          }));
                        },
                        child: Text('Sign up'),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
