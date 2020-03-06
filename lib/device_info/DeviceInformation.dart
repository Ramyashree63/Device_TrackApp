import 'dart:io' show Platform;
import 'package:battery/battery.dart';

import 'package:device_info/device_info.dart';
import 'package:firebase_database/firebase_database.dart';

class DeviceInformation {
  static const OPERATING_SYSTEM = "Operating System";
  static const VERSION = "DeviceSDKVersion";
  static const MANUFACTURER = "DeviceManufacturerName";
  static const MODEL = "DeviceModel";
  static const BATTERY_LEVEL = "Battery Level";
  static const USER_ACTIVE = "active";
  static const USER_IN_ACTIVE = "in active";
  String mDeviceOperatingSystem;
  String mDeviceSDKVersion;
  String mDeviceManufacturerName;
  String mDeviceModel;
  String mDateTime;
  final dataBaseReferance = FirebaseDatabase.instance.reference();
  final Battery battery = Battery();

  Future<String> getDeviceDetails(String isUserActive) async {
    var mBatteryLvel = await battery.batteryLevel;
    mDateTime = DateTime.now().toString();
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      mDeviceOperatingSystem = androidInfo.version.release;
      mDeviceSDKVersion = androidInfo.version.sdkInt.toString();
      mDeviceManufacturerName = androidInfo.manufacturer;
      mDeviceModel = androidInfo.model;

      dataBaseReferance.child(mDateTime + "_user").set({
        OPERATING_SYSTEM: mDeviceOperatingSystem,
        VERSION: mDeviceSDKVersion,
        MANUFACTURER: mDeviceManufacturerName,
        MODEL: mDeviceModel,
        BATTERY_LEVEL: mBatteryLvel,
        USER_ACTIVE: isUserActive
      });
/*      print(
          'Android: $mDeviceOperatingSystem (\nSDK: $mDeviceSDKVersion), (\nManufaturer: $mDeviceManufacturerName) (\nModel: $mDeviceModel)');*/
      return 'Android: $mDeviceOperatingSystem \nSDK: $mDeviceSDKVersion, \nManufaturer: $mDeviceManufacturerName \nModel: $mDeviceModel \nBattery Level :  $mBatteryLvel';
    } else if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      mDeviceOperatingSystem = iosInfo.systemName;
      mDeviceSDKVersion = iosInfo.systemVersion;
      mDeviceManufacturerName = iosInfo.name;
      mDeviceModel = iosInfo.model;

      dataBaseReferance.child(mDateTime + "_user").set({
        OPERATING_SYSTEM: mDeviceOperatingSystem,
        VERSION: mDeviceSDKVersion,
        MANUFACTURER: mDeviceManufacturerName,
        MODEL: mDeviceModel,
        BATTERY_LEVEL: mBatteryLvel,
        USER_ACTIVE: isUserActive
      });
      /*print(
          '$mDeviceOperatingSystem $mDeviceSDKVersion, $mDeviceManufacturerName $mDeviceModel');*/
      return '$mDeviceOperatingSystem $mDeviceSDKVersion, $mDeviceManufacturerName $mDeviceModel $mBatteryLvel';
    }
    return "";
  }
}
