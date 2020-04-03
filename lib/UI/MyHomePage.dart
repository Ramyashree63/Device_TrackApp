import 'package:final_app/ListDetailsScreen/first_screen.dart';
import 'package:final_app/Utilities/Utills.dart';
import 'package:flutter/material.dart';

import 'login_in.dart';
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Utills.getPrefernce().then((isLogin) {
      if (isLogin) {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => ListViewScreen()));
      } else {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(child: Container()),
    );
  }
}
