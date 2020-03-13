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
  String mDeviceOperatingSystem;
  String mDeviceSDKVersion;
  String mDeviceManufacturerName;
  String mDeviceModel;
  String mDateTime;
  final Battery battery = Battery();
  var mBatteryLevel;
  static String deviceID;
  Future<String> getDeviceDetails(String isUserActive) async {
    final dataBaseReferance = FirebaseDatabase.instance.reference();
    mBatteryLevel = await battery.batteryLevel;
    DateTime time = DateTime.now();
    String utcTime = time.millisecondsSinceEpoch.toString();
    mDateTime = time.toString();
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      mDeviceOperatingSystem = "Android: " + androidInfo.version.release;
      mDeviceSDKVersion = androidInfo.version.sdkInt.toString();
      mDeviceManufacturerName = androidInfo.manufacturer;
      mDeviceModel = androidInfo.model;
      deviceID = androidInfo.androidId;
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
        USER_NAME: "user name",
        DEVICE_ID: androidInfo.androidId
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
        OPERATING_SYSTEM: "IOS: " + mDeviceOperatingSystem,
        VERSION: mDeviceSDKVersion,
        MANUFACTURER: mDeviceManufacturerName,
        MODEL: mDeviceModel,
        BATTERY_LEVEL: mBatteryLevel,
        USER_STATUS: isUserActive,
        TIME: mDateTime,
        USER_NAME: "user name",
        DEVICE_ID: iosInfo.identifierForVendor
      });

      return '$mDeviceOperatingSystem $mDeviceSDKVersion, $mDeviceManufacturerName $mDeviceModel $mBatteryLevel';
    }
    return "";
  }
}
