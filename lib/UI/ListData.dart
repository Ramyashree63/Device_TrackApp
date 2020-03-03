import 'package:flutter/material.dart';
import 'package:google_sign_in_app/device_info/DeviceInformation.dart';

class ListData extends StatefulWidget {
  @override
  _ListDataState createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
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
        title: Text("DeviceInfo"),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: updateDeivceInfo)
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
}
