import 'package:final_app/ListDetailsScreen/first_screen.dart';
import 'package:final_app/Utilities/Utills.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:final_app/UI/login_in.dart';

import 'UI/MyHomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isLogIn;
    Utills.getPrefernce().then((isLogin) {
      isLogIn = isLogin;
    });
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: MyHomePage());
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


/*FlareActor(
//          "assets/images/splash.flr",
"assets/images/Teddy.flr",
fit: BoxFit.fill,
alignment: Alignment.center,
animation: "idle",
),*/
