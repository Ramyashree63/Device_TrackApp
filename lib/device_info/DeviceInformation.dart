import 'dart:io' show Platform;
import 'package:battery/battery.dart';

import 'package:device_info/device_info.dart';

class DeviceInformation {
  String mDeviceOperatingSystem;
  String mDeviceSDKVersion;
  String mDeviceManufacturerName;
  String mDeviceModel;

  final Battery battery = Battery();
  Future<String> getDeviceDetails() async {
    var mBatteryLvel = await battery.batteryLevel;

    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      mDeviceOperatingSystem = androidInfo.version.release;
      mDeviceSDKVersion = androidInfo.version.sdkInt.toString();
      mDeviceManufacturerName = androidInfo.manufacturer;
      mDeviceModel = androidInfo.model;

      print(
          'Android: $mDeviceOperatingSystem (\nSDK: $mDeviceSDKVersion), (\nManufaturer: $mDeviceManufacturerName) (\nModel: $mDeviceModel)');
      return 'Android: $mDeviceOperatingSystem \nSDK: $mDeviceSDKVersion, \nManufaturer: $mDeviceManufacturerName \nModel: $mDeviceModel \nBattery Level :  $mBatteryLvel';
    } else if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      mDeviceOperatingSystem = iosInfo.systemName;
      mDeviceSDKVersion = iosInfo.systemVersion;
      mDeviceManufacturerName = iosInfo.name;
      mDeviceModel = iosInfo.model;
      print(
          '$mDeviceOperatingSystem $mDeviceSDKVersion, $mDeviceManufacturerName $mDeviceModel');
      return '$mDeviceOperatingSystem $mDeviceSDKVersion, $mDeviceManufacturerName $mDeviceModel $mBatteryLvel';
    }
    return "";
  }
}
