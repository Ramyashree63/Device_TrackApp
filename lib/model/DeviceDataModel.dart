class DeviceDataModel {
  String operatingSystem;
  String sdkVersion;
  String manufacturer;
  String model;
  String time;
  String isActive;
  int batteryLevel;
  String userName;
  DeviceDataModel(this.operatingSystem, this.sdkVersion, this.manufacturer,
      this.model, this.batteryLevel, this.isActive, this.time, this.userName);
}
