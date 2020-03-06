import 'package:final_app/device_info/DeviceInformation.dart';
import 'package:final_app/model/DeviceDataModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:final_app/UI/login_in.dart';
import 'package:final_app/FireBase/sign_in.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform, sleep;

class FirstScreen extends StatefulWidget {
  static const USER_ACTIVE = "active";
  static const USER_IN_ACTIVE = "in active";
  static const LOG_OUT = "LOG OUT";

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  String mDeviceDetails;
  List<DeviceDataModel> mDeviceDataList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    databaseReference.child("Android").once().then((DataSnapshot snapShot) {
      var keys = snapShot.value.keys;
      var data = snapShot.value;
      mDeviceDataList.clear();
      for (var key in keys) {
        mDeviceDataList.add(new DeviceDataModel(
            data[key]["operatingSystem"],
            data[key]["sdkVersion"],
            data[key]["manufacturer"],
            data[key]["model"],
            data[key]["batteryLevel"],
            data[key]["isActive"],
            data[key]["time"],
            data[key]["userName"]));
      }
      setState(() {
        print("Length : ${mDeviceDataList.length}");
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
              onPressed: () {
                DeviceInformation().getDeviceDetails(FirstScreen.USER_ACTIVE);
              }),
          FlatButton(
            textColor: Colors.white,
            child: Text(FirstScreen.LOG_OUT),
            onPressed: () {
              signOutGoogle();
              DeviceInformation().getDeviceDetails(FirstScreen.USER_IN_ACTIVE);
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
        child: mDeviceDataList.length == 0
            ? Text("No Data is Available")
            : ListView.builder(
                itemBuilder: (_, index) {
                  return listUI(
                    mDeviceDataList[index].operatingSystem,
                    mDeviceDataList[index].sdkVersion,
                    mDeviceDataList[index].manufacturer,
                    mDeviceDataList[index].model,
                    mDeviceDataList[index].batteryLevel,
                    mDeviceDataList[index].isActive,
                    mDeviceDataList[index].time,
                    mDeviceDataList[index].userName,
                  );
                },
                itemCount: mDeviceDataList.length),
      ),
    );
  }

  Widget listUI(
      String operatingSystem,
      String sdkVersion,
      String manufacturer,
      String model,
      String batteryLevel,
      String isActive,
      String time,
      String userName) {
    return Card(
      elevation: 10.0,
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("OPERATING_SYSTEM : $operatingSystem",
                style: TextStyle(fontSize: 18.0)),
            Text(
              "VERSION : $sdkVersion",
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              "MANUFACTURER : $manufacturer",
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              "MODEL : $model",
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              "BATTERY_LEVEL : $batteryLevel",
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              "USER_STATUS : $isActive",
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              "TIME : $time",
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              "USER_NAME : $userName",
              style: TextStyle(fontSize: 18.0),
            ),
          ],
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
