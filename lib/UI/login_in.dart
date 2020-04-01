import 'dart:io';

import 'package:final_app/Utilities/Utills.dart';
import 'package:final_app/device_info/DeviceInformation.dart';
import 'package:flutter/material.dart';
import 'package:final_app/FireBase/sign_in.dart';
import 'package:final_app/ListDetailsScreen/first_screen.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginPageState();
  }
}

String _email;

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color.fromRGBO(152, 226, 254, 1),
                Color.fromRGBO(50, 171, 126, 1)
              ])),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              SizedBox(height: 20),
              Image(image: AssetImage("assets/images/top_image_art.png"),
              width: 250,height: 250),
                Text(
                  "Welcome to Device Tracker",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 52.0,
                    fontFamily: 'Gibson',
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "The best way to track your device. Let's get started!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontFamily: 'Gibson',
                  ),
                ),
                SizedBox(height: 60),
                RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0))),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                            image: AssetImage("assets/images/google_logo.png"),
                            height: 30.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Sign in with Google',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Gibson',
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  onPressed: () {
                    emailValidate(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void startServiceInPlatform() async {
    if (Platform.isAndroid) {
      var methodChannel = MethodChannel("com.example.google_sign_in_app");
      String data = await methodChannel.invokeMethod("startService");
      debugPrint(data);
      print("service started and battery level = $data");
    } else if (Platform.isIOS) {}
  }

  Future<void> emailValidate(BuildContext context) {
    Utills.connectivityCheck(context).then((isConncted) {
      if (isConncted != null && isConncted) {
        DeviceInformation.userName = "";
        signInWithGoogle().then((value) {
          if (value != null && value.email != null) {
            _email = value.email;
          } else {
            invalidateCache();
            return;
          }
          print(_email);
          if (!RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@dreamorbit.com")
              .hasMatch(_email)) {
            invalidateCache();
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
//                  startServiceInPlatform();
                  DeviceInformation.userName = value.displayName;
//                  MyApp.isUserLoggedIn = true;
                  return FirstScreen();
                },
              ),
            );
          }
        });
      }
    });
  }

  Future<void> ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid Email!!'),
          content: const Text('Please enter a valid Email Address!!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                emailValidate(context);
              },
            ),
          ],
        );
      },
    );
  }

  void invalidateCache() {
    ackAlert(context);
    signOutGoogle();
    clearCache();
    print("Enter an valid Email Address!!");
  }
}
