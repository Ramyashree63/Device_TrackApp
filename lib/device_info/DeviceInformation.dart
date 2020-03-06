import 'dart:io' show Platform, sleep;
import 'dart:math';
import 'package:battery/battery.dart';

import 'package:device_info/device_info.dart';
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
  String mDeviceOperatingSystem;
  String mDeviceSDKVersion;
  String mDeviceManufacturerName;
  String mDeviceModel;
  String mDateTime;
  final dataBaseReferance = FirebaseDatabase.instance.reference();
  final Battery battery = Battery();
  var mBatteryLevel;

  Future<String> getDeviceDetails(String isUserActive) async {
    mBatteryLevel = await battery.batteryLevel;
    DateTime time = DateTime.now();
    String utcTime = time.millisecondsSinceEpoch.toString();
    mDateTime = time.toString();
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      mDeviceOperatingSystem = "Android "+androidInfo.version.release;
      mDeviceSDKVersion = androidInfo.version.sdkInt.toString();
      mDeviceManufacturerName = androidInfo.manufacturer;
      mDeviceModel = androidInfo.model;
      FirebaseDatabase.instance
          .reference()
          .child("Android")
          .child(utcTime)
          .set({
        OPERATING_SYSTEM: mDeviceOperatingSystem,
        VERSION: mDeviceSDKVersion,
        MANUFACTURER: mDeviceManufacturerName,
        MODEL: mDeviceModel,
        BATTERY_LEVEL: mBatteryLevel,
        USER_STATUS: isUserActive,
        TIME: mDateTime,
        USER_NAME: "user name"
      });
/*      print(
          'Android: $mDeviceOperatingSystem (\nSDK: $mDeviceSDKVersion), (\nManufaturer: $mDeviceManufacturerName) (\nModel: $mDeviceModel)');*/
      return 'Android: $mDeviceOperatingSystem \nSDK: $mDeviceSDKVersion, \nManufaturer: $mDeviceManufacturerName \nModel: $mDeviceModel \nBattery Level :  $mBatteryLevel';
    } else if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      mDeviceOperatingSystem = iosInfo.systemName;
      mDeviceSDKVersion = iosInfo.systemVersion;
      mDeviceManufacturerName = iosInfo.name;
      mDeviceModel = iosInfo.model;

      dataBaseReferance.child("IOS").child(utcTime).set({
        OPERATING_SYSTEM: mDeviceOperatingSystem,
        VERSION: mDeviceSDKVersion,
        MANUFACTURER: mDeviceManufacturerName,
        MODEL: mDeviceModel,
        BATTERY_LEVEL: mBatteryLevel,
        USER_STATUS: isUserActive,
        TIME: mDateTime,
        USER_NAME: "user name"
      });
      /*print(
          '$mDeviceOperatingSystem $mDeviceSDKVersion, $mDeviceManufacturerName $mDeviceModel');*/
      return '$mDeviceOperatingSystem $mDeviceSDKVersion, $mDeviceManufacturerName $mDeviceModel $mBatteryLevel';
    }
    return "";
  }
}
