import 'package:firebase_auth/firebase_auth.dart';
import 'package:polutionheatmap/Services/AppCard.dart';
import 'package:flutter/material.dart';
import 'package:polutionheatmap/Services/LoginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email, password, name, confirmPass, _displayName;
  bool _autoValidate = false;
  String errorMsg = "";

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  void initState() {
    super.initState();
  }

  Future<void> createUser() async {
    final formState = formKey.currentState;
    if (formKey.currentState.validate()) {
      formState.save();

      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: email, password: password))
            .user;

        UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
        userUpdateInfo.displayName = _displayName;
        user.updateProfile(userUpdateInfo).then((onValue) {
          Firestore.instance.collection('users').document().setData(
              {'email': email, 'displayName': _displayName}).then((onValue) {});
        });

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return LogInPage();
        }));
      } catch (error) {
        switch (error.code) {
          case "ERROR_EMAIL_ALREADY_IN_USE":
            {
              setState(() {
                errorMsg = "This email is already in use.";
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
          case "ERROR_WEAK_PASSWORD":
            {
              setState(() {
                errorMsg = "The password must be 6 characters long or more.";
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

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        title: Center(
          child: Text(
            'Polution Heat Map',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                  width: double.infinity,
                  child: Divider(
                    color: Colors.teal,
                  ),
                ),
                AppCard(
                  child: Container(
                    height: 30,
                    child: Text(
                      'Register',
                      style: TextStyle(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                AppCard(
                  child: Container(
                    child: Form(
                      key: formKey,
                      autovalidate: _autoValidate,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Name'),
                            // ignore: missing_return
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Please enter your name';
                              }
                            },
                            onSaved: (input) => _displayName = input,
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Email'),
                            // ignore: missing_return
                            validator: (input) {
                              input.isEmpty ? "*Required" : null;
                              hint:
                              "PASSWORD";
                            },
                            onSaved: (input) => email = input,
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Password'),
                            // ignore: missing_return
                            validator: (input) {
                              input.isEmpty ? "*Required" : null;
                            },
                            obscureText: true,
                            onSaved: (input) => password = input,
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Confirm password'),
                            // ignore: missing_return
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Please confrim you password';
                              } else if (confirmPass != password) {
                                return 'Please password does not match';
                              }
                            },
                            obscureText: true,
                            onSaved: (input) => confirmPass = input,
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 20.0),
                            child: FlatButton(
                                color: Colors.black,
                                textColor: Colors.white,
                                onPressed: createUser,
                                child: Text('Create')),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
