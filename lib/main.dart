import 'package:final_app/ListDetailsScreen/first_screen.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:final_app/UI/login_in.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: LoginPage()
    );
  }
}

/*SplashScreen.navigate(
name: "assets/images/splash.flr",
next: (context) => LoginPage(),
startAnimation: "1",
loopAnimation: "1",
endAnimation: "1",
until: () => Future.delayed(Duration(seconds: 5)),
),*/

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState()=> _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: FlareActor(
          "assets/images/splash.flr",
          fit: BoxFit.fill,
          alignment: Alignment.center,
          animation: "idle",
        ),
      ),
    );
  }
}
