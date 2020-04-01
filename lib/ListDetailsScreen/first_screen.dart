import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_app/Utilities/Utills.dart';
import 'package:final_app/device_info/DeviceInformation.dart';
import 'package:final_app/main.dart';
import 'package:final_app/model/DeviceDataModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:final_app/UI/login_in.dart';
import 'package:final_app/FireBase/sign_in.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform, sleep;

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  String mDeviceTocken;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<DeviceDataModel> mDeviceDataList = [];
  Firestore mFirestore = Firestore.instance;

//  final List<Message> messages=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    const channelName = 'com.example.google_sign_in_app';
    var methodChannel = MethodChannel(channelName);
    methodChannel.setMethodCallHandler(this.didRecieveTranscript);

    firebaseMessagingInitialize();
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
            data[key]["deviceID"],
            data[key]["token"]));
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
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color.fromRGBO(152, 226, 254, 1),
                Color.fromRGBO(50, 171, 126, 1)
              ])),
        ),
        title: Text(
          "Device Info",
          style: TextStyle(
            fontFamily: 'Gibson',
            fontWeight: FontWeight.w400,
          ),
        ),
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
                      DeviceInformation().getDeviceDetails(
                          FirstScreen.USER_ACTIVE, mDeviceTocken);
                    }
                  });
                }),
          ),
          Builder(
            builder: (context) => IconButton(
              icon: Image.asset("assets/images/ic_logout.png"),
              tooltip: "Log out",
              onPressed: () {
                _logOut(context);
              },
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
                  mDeviceDataList[index].deviceID,
                  mDeviceDataList[index].token);
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
      String dateTime,
      String userName,
      String deviceID,
      String token) {
    bool isCurrentUser = true;
    if (deviceID == DeviceInformation.deviceID) {
      isCurrentUser = false;
    }

    String mDate = dateTime.split(" ").first;
    String mTime = dateTime.split(" ").last;
    return Card(
      color: Colors.white,
      elevation: 50.0,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            buildingTopRowItem("$userName", "$mTime"),
            Divider(
              color: Colors.black,
            ),
            sizedBoxHeight(),
            buildingRowItem("Operating System", "$operatingSystem"),
            sizedBoxHeight(),
            buildingRowItem("Version", "$sdkVersion"),
            sizedBoxHeight(),
            buildingRowItem("Battery Level", "$batteryLevel"),
            sizedBoxHeight(),
            buildingRowItem("Model", "$model"),
            sizedBoxHeight(),
            buildingRowItem("Manufacturer", "$manufacturer"),
            sizedBoxHeight(),
            buildingRowItem("User Status", "$isActive"),
            sizedBoxHeight(),
            buildingRowItem("Date ", "$mDate"),
            sizedBoxHeight(),
            Divider(
              color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                (isActive == FirstScreen.USER_ACTIVE && isCurrentUser)
                    ? RaisedButton.icon(
                        icon: Icon(
                          Icons.phone_iphone,
                          color: Colors.white,
                        ),
                        color: Color.fromRGBO(2, 82, 151, 1),
                        label: Text(FirstScreen.ASK_DEVICE,
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.white)),
                        splashColor: Colors.tealAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        onPressed: () {
//                    _firebaseMessaging.onTokenRefresh.listen(sendTokenToServer);
//                    _firebaseMessaging.getToken();
//                    _firebaseMessaging.subscribeToTopic("sendNotification");

                          mFirestore.collection(FirstScreen.DEVICE_INFO +
                              "/" +
                              deviceID +
                              "/token" +
                              token);
                        },
                      )
                    : RaisedButton.icon(
                        icon: Icon(
                          Icons.phone_iphone,
                          color: Colors.white,
                        ),
                        label: Text(FirstScreen.ASK_DEVICE,
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.white)),
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

  Widget buildingRowItem(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("$key :",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: 'Gibson',
                fontWeight: FontWeight.w400,
                fontSize: 12.0,
                color: Color.fromARGB(69, 69, 83, 1))),
        Text(" $value",
            textAlign: TextAlign.end,
            textDirection: TextDirection.rtl,
            style: TextStyle(
                fontFamily: 'Gibson',
                fontWeight: FontWeight.w700,
                fontSize: 12.0,
                color: Colors.black)),
      ],
    );
  }

  Widget buildingTopRowItem(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("$key :",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: 'Gibson',
                fontWeight: FontWeight.w700,
                fontSize: 14.0,
                color: Colors.black)),
        RichText(
            text: TextSpan(children: [
          WidgetSpan(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Icon(Icons.access_time),
          )),
          TextSpan(
              text: " $value",
              style: TextStyle(
                  fontFamily: 'Gibson',
                  fontWeight: FontWeight.w700,
                  fontSize: 12.0,
                  color: Colors.black)),
        ])),
      ],
    );
  }

  Widget sizedBoxHeight() {
    return SizedBox(
      height: 10,
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
//        MyApp.isUserLoggedIn = false;
        signOutGoogle();
        clearCache();
        DeviceInformation.deviceID = "";
        DeviceInformation()
            .getDeviceDetails(FirstScreen.USER_IN_ACTIVE, mDeviceTocken);
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
        DeviceInformation()
            .getDeviceDetails("FirstScreen.USER_ACTIVE", mDeviceTocken);
    }
  }

  void firebaseMessagingInitialize() {
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print("on Message  $message");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: ListTile(
            title: Text(message['notification']['title']),
            subtitle: Text(message['notification']['body']),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                DeviceInformation().getDeviceDetails(
                    FirstScreen.USER_IN_ACTIVE, mDeviceTocken);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      return;
    }, onResume: (Map<String, dynamic> message) {
      print("on Reume Message  $message");
      showFlutterNotification(
          message['notification']['title'], message['notification']['body']);
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print("on Launch Message  $message");
      showFlutterNotification(
          message['notification']['title'], message['notification']['body']);
      return;
    });

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token) {
      mDeviceTocken = token;
      print("token $token");
      DeviceInformation().getDeviceDetails(FirstScreen.USER_ACTIVE, token);
    });
  }

  Future<void> showFlutterNotification(String title, String body) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: null); //onDidRecieveLocationLocation
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: null); //onSelectNotification

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'item id 2');
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

  void sendTokenToServer(String fcmToken) {
    print("Token ${fcmToken}");
  }
}
