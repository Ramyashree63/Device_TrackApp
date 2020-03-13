import 'dart:io';

import 'package:final_app/Utilities/Utills.dart';
import 'package:final_app/device_info/DeviceInformation.dart';
import 'package:flutter/material.dart';
import 'package:final_app/FireBase/sign_in.dart';
import 'package:final_app/ListDetailsScreen/first_screen.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder (
        builder: (context) => Container(
          color: Colors.black12,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlutterLogo(size: 120),
                SizedBox(height: 30),
                OutlineButton(
                  splashColor: Colors.grey,
                  onPressed: () {
                    _googleSignIn(context);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  highlightElevation: 0,
                  borderSide: BorderSide(color: Colors.black54),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                            image: AssetImage("assets/images/google_logo.png"),
                            height: 20.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Sign in with Google',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _googleSignIn(BuildContext context) {
    Utills.connectivityCheck(context).then((isConncted) {
      if (isConncted != null && isConncted) {
        signInWithGoogle().whenComplete(() {
          startServiceInPlatform();
          DeviceInformation().getDeviceDetails(FirstScreen.USER_ACTIVE);
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return FirstScreen();
                },
              ),
            );
          });
        });
      }
    });
  }

  void startServiceInPlatform() async {
    if (Platform.isAndroid) {
      var methodChannel = MethodChannel("com.example.google_sign_in_app");
      String data = await methodChannel.invokeMethod("startService");
      debugPrint(data);
      print("service started and battery level = $data");
    } else if (Platform.isIOS) {}
  }
}
