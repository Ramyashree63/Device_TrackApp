import 'package:device_info/device_info.dart';
import 'package:final_app/Utilities/Utills.dart';
import 'package:final_app/device_info/DeviceInformation.dart';
import 'package:final_app/model/DeviceDataModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:final_app/UI/login_in.dart';
import 'package:final_app/FireBase/sign_in.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform, sleep;

import 'package:flutter/widgets.dart';

class FirstScreen extends StatefulWidget {
  static const USER_ACTIVE = "active";
  static const USER_IN_ACTIVE = "in active";
  static const LOG_OUT = "LOG OUT";
  static const DEVICE_INFO = "Device Info";
  static const ASK_DEVICE = "Ask for device";

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
    const channelName = 'com.example.google_sign_in_app';
    var methodChannel = MethodChannel(channelName);
    methodChannel.setMethodCallHandler(this.didRecieveTranscript);

    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    databaseReference
        .child(FirstScreen.DEVICE_INFO)
        .once()
        .then((DataSnapshot snapShot) {
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
            data[key]["userName"],
            data[key]["deviceID"]));
      }
      mDeviceDataList.sort((a, b) => a.time.compareTo(b.time));
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
          Builder(
            builder: (context) => IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  Utills.connectivityCheck(context).then((isConncted) {
                    if (isConncted != null && isConncted) {
                      DeviceInformation()
                          .getDeviceDetails(FirstScreen.USER_ACTIVE);
                    }
                  });
                }),
          ),
          Builder(
            builder: (context) => FlatButton(
              textColor: Colors.white,
              child: Text(FirstScreen.LOG_OUT),
              onPressed: () {
                _logOut(context);
              },
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ),
        ],
      ),
      body: Container(
        child: ListView.builder(
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
                  mDeviceDataList[index].deviceID);
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
      int batteryLevel,
      String isActive,
      String time,
      String userName,
      String deviceID) {
    bool isCurrentUser = true;
    if(deviceID == DeviceInformation.deviceID){
      isCurrentUser = false;
    }
    /*checkUserAvailable(deviceID).then((onValue) {
      isCurrentUser = onValue;
    });*/
    return Card(
      color: Colors.white,
      elevation: 10.0,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("OPERATING_SYSTEM : $operatingSystem",
                style: TextStyle(fontSize: 16.0)),
            Text(
              "VERSION : $sdkVersion",
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              "MANUFACTURER : $manufacturer",
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              "MODEL : $model",
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              "BATTERY_LEVEL : $batteryLevel",
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              "USER_STATUS : $isActive",
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              "TIME : $time",
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              "USER_NAME : $userName",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                (isActive == FirstScreen.USER_ACTIVE && isCurrentUser)
                    ? RaisedButton(
                        color: Colors.green,
                        child: Text(FirstScreen.ASK_DEVICE),
                        splashColor: Colors.tealAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        onPressed: () {},
                      )
                    : RaisedButton(
                        child: Text(FirstScreen.ASK_DEVICE),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))))
              ],
            )
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

  void _logOut(BuildContext context) {
    Utills.connectivityCheck(context).then((isConncted) {
      if (isConncted != null && isConncted) {
        signOutGoogle();
        DeviceInformation.deviceID = "";
        DeviceInformation().getDeviceDetails(FirstScreen.USER_IN_ACTIVE);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return LoginPage();
        }), ModalRoute.withName('/'));
        stopService(context);
      }
    });
  }

  Future<void> didRecieveTranscript(MethodCall call) async {
    // type inference will work here avoiding an explicit cast
    final String utterance = call.arguments;
    switch (call.method) {
      case "didRecieveTranscript":
        DeviceInformation().getDeviceDetails("FirstScreen.USER_ACTIVE");
    }
  }
/*
use in future
  Future<bool> checkUserAvailable(String deviceID) async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      String id = androidInfo.androidId;
      if (id.toLowerCase() == deviceID.toLowerCase()) {
        return true;
      } else {
        return false;
      }
    } else if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      String id = iosInfo.identifierForVendor;
      if (id.toLowerCase() == deviceID.toLowerCase()) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }*/
}
