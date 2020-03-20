import 'dart:io' show Platform, sleep;
import 'dart:math';
import 'package:battery/battery.dart';

import 'package:device_info/device_info.dart';
import 'package:final_app/ListDetailsScreen/first_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class DeviceInformation {
  static const OPERATING_SYSTEM = "operatingSystem";
  static const VERSION = "sdkVersion";
  static const MANUFACTURER = "manufacturer";
  static const MODEL = "model";
  static const BATTERY_LEVEL = "batteryLevel";
  static const USER_STATUS = "isActive";
  static const TIME = "time";
  static const USER_NAME = "userName";
  static const DEVICE_ID = "deviceID";
  static const DEVICE_TOKEN = "token";
  String mDeviceOperatingSystem;
  String mDeviceSDKVersion;
  String mDeviceManufacturerName;
  String mDeviceModel;
  String mDateTime;
  final Battery battery = Battery();
  var mBatteryLevel;
  static String deviceID;
  static String userName;

  Future<String> getDeviceDetails(String isUserActive, String token) async {
    final dataBaseReferance = FirebaseDatabase.instance.reference();
    try {
      mBatteryLevel = await battery.batteryLevel;
    } catch (e) {
      print('Fetching battery level in iOS_Simulator ${e}');
    }
    DateTime time = DateTime.now();
    String utcTime = time.millisecondsSinceEpoch.toString();
    mDateTime = time.toString();
    String mTocken;
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      mDeviceOperatingSystem = "Android: " + androidInfo.version.release;
      mDeviceSDKVersion = androidInfo.version.sdkInt.toString();
      mDeviceManufacturerName = androidInfo.manufacturer;
      mDeviceModel = androidInfo.model;
      deviceID = androidInfo.androidId;
      if (token != null && token.isNotEmpty) {
        mTocken = token;
      }
      dataBaseReferance
          .child(FirstScreen.DEVICE_INFO)
          .child(androidInfo.androidId)
          .set({
        OPERATING_SYSTEM: mDeviceOperatingSystem,
        VERSION: mDeviceSDKVersion,
        MANUFACTURER: mDeviceManufacturerName,
        MODEL: mDeviceModel,
        BATTERY_LEVEL: mBatteryLevel,
        USER_STATUS: isUserActive,
        TIME: mDateTime,
        USER_NAME: userName,
        DEVICE_ID: androidInfo.androidId,
        DEVICE_TOKEN: mTocken
      });
      return 'Android: $mDeviceOperatingSystem \nSDK: $mDeviceSDKVersion, \nManufaturer: $mDeviceManufacturerName \nModel: $mDeviceModel \nBattery Level :  $mBatteryLevel';
    } else if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      mDeviceOperatingSystem = iosInfo.systemName;
      mDeviceSDKVersion = iosInfo.systemVersion;
      mDeviceManufacturerName = iosInfo.name;
      mDeviceModel = iosInfo.model;
      deviceID = iosInfo.identifierForVendor;
      dataBaseReferance
          .child(FirstScreen.DEVICE_INFO)
          .child(iosInfo.identifierForVendor)
          .set({
        OPERATING_SYSTEM: mDeviceOperatingSystem,
        VERSION: mDeviceSDKVersion,
        MANUFACTURER: mDeviceManufacturerName,
        MODEL: mDeviceModel,
        BATTERY_LEVEL: mBatteryLevel,
        USER_STATUS: isUserActive,
        TIME: mDateTime,
        USER_NAME: userName,
        DEVICE_ID: iosInfo.identifierForVendor,
        DEVICE_TOKEN: mTocken
      });

      return '$mDeviceOperatingSystem $mDeviceSDKVersion, $mDeviceManufacturerName $mDeviceModel $mBatteryLevel';
    }
    return "";
  }
}
