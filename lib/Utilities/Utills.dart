import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

final Connectivity _connectivity = new Connectivity();

class Utills {
  static const String network_connectoin = "No network connection";
  static const String ok = "OK";
  static Future<bool> connectivityCheck(BuildContext context) async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      showNetworkSnackBar(context);
      return false;
    } else if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      return true;
    }
    showNetworkSnackBar(context);
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

  static void showNetworkSnackBar(BuildContext context) {
    final _scaffold = Scaffold.of(context);
    _scaffold.showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(network_connectoin, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    ));
  }
}
