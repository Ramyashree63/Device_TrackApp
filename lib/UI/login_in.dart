import 'package:flutter/material.dart';
import 'package:final_app/FireBase/sign_in.dart';
import 'package:final_app/ListDetailsScreen/first_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginPageState();
  }
}

String _email;

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.cyan,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(size: 120),
              SizedBox(height: 30),
              OutlineButton(
                splashColor: Colors.grey,
                onPressed: () {
                  email_validate(context);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                highlightElevation: 0,
                borderSide: BorderSide(color: Colors.grey),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                       Image(image: AssetImage("assets/images/google_logo.png"), height: 20.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Sign in with Google',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future <void> email_validate(BuildContext context){
  signInWithGoogle().then((value) {
    _email = value.email;
    print(_email);
    if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@dreamorbit.com").hasMatch(_email)){
      ackAlert(context);
      signOutGoogle();
      clearCache();
      print("Enter an valid Email Address!!");
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return FirstScreen();
      },),);
    }
  });
}

Future<void> ackAlert(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Invalid Email!!'),
        content: const Text('Please enter a valid Email Address!!'),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
              email_validate(context);
            },
          ),
        ],
      );
    },
  );
}