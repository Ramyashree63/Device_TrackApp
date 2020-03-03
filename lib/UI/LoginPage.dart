import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in_app/device_info/DeviceInformation.dart';
import 'package:google_sign_in_app/fireBase/signInGoogle.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String mDeviceDetails;

  updateDeivceInfo() async {
    setState(() {
      DeviceInformation().getDeviceDetails().then((value) {
        mDeviceDetails = value.toString();
      });
    });
  }

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
              _signInButton(),
              _deviceDetails()
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
//        signInWithGoogle();
//        updateDeivceInfo();
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

  Widget _deviceDetails() {
    return GestureDetector(
      onTap: updateDeivceInfo,
      child: Text(
        mDeviceDetails != null
            ? "Device Details: \n$mDeviceDetails"
            : "Device Details:",
        style: TextStyle(fontSize: 21, color: Colors.indigo),
        softWrap: true,
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
