import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in_app/device_info/DeviceInformation.dart';
import 'package:google_sign_in_app/fireBase/signInGoogle.dart';

import 'ListData.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(size: 100),
              _signInButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton(BuildContext context) {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
//        signInWithGoogle();
      launchNextScreen(context);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage("assets/images/btn_google_signin.png"),
            height: 35.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Sign in",
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void launchNextScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ListData()),);
  }
}
