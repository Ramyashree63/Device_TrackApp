import 'package:final_app/device_info/DeviceInformation.dart';
import 'package:flutter/material.dart';
import 'package:final_app/UI/login_in.dart';
import 'package:final_app/FireBase/sign_in.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:device_info/device_info.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Device Info"),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: updateDeivceInfo),
          FlatButton(
            textColor: Colors.white,
            child: Text("LOG OUT"),
            onPressed: () {
              signOutGoogle();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) {
                return LoginPage();
              }), ModalRoute.withName('/'));
              stopService(context);
            },
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue[100], Colors.blue[400]],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: 40),
              Text(
                mDeviceDetails != null
                    ? "Device Details: \n$mDeviceDetails"
                    : "Device Details:",
                style: TextStyle(fontSize: 21, color: Colors.indigo),
                softWrap: true,
                textAlign: TextAlign.justify,
              ),
/*              RaisedButton(
                onPressed: () {
                  signOutGoogle();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }), ModalRoute.withName('/'));
                },
                color: Colors.deepPurple,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
              )*/
            ],
          ),
        ),
      ),
    );
  }

  void stopService(BuildContext context) async {
    if (Platform.isAndroid) {
      var methodChannel = MethodChannel("com.example.google_sign_in_app");
      String data = await methodChannel.invokeMethod("stopService");
      if (data.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } else if (Platform.isIOS) {}
  }
}
