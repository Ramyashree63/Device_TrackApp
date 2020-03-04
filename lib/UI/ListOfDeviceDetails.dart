
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in_app/UI/LoginPage.dart';
import 'package:google_sign_in_app/device_info/DeviceInformation.dart';
import 'dart:io';

class ListOfDeviceDetails extends StatefulWidget {
  @override
  _ListOfDeviceDetailsState createState() => _ListOfDeviceDetailsState();
}

class _ListOfDeviceDetailsState extends State<ListOfDeviceDetails> {
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
              stopService(context);
            },
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          )
        ],
      ),
      body: Container(
        child: Text(
          mDeviceDetails != null
              ? "Device Details: \n$mDeviceDetails"
              : "Device Details:",
          style: TextStyle(fontSize: 21, color: Colors.indigo),
          softWrap: true,
          textAlign: TextAlign.justify,
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
    } else if(Platform.isIOS){

    }
  }
}
