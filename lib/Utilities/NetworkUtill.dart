import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

final Connectivity _connectivity = new Connectivity();

class NetworkUtill {
  static Future<bool> ConnectivityCheck(BuildContext context) async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      showAlertDialog(context);
      return false;
    } else if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      return true;
    }
    showAlertDialog(context);
    return false;
  }

  static showAlertDialog(BuildContext context){
    showDialog(context: context,
    builder: (BuildContext buildContext){
      return AlertDialog(
        title: new Text("Network Connection "),
        content: new Text("Please do check your Network Connection"),
        actions: <Widget>[
          new FlatButton(onPressed: (){
          Navigator.of(context).pop();
          }, child: Text("CLOSE"))
        ],
      );
    });
  }
}
