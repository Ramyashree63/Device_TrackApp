import 'package:final_app/FireBase/sign_in.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController _emailFeild;
  TextEditingController _password;
  @override
  void initState() {
    super.initState();
    _emailFeild = TextEditingController(text: "");
    _password = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 300.0),
              TextField(
                controller: _emailFeild,
                decoration: InputDecoration(hintText: "Enter the email"),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(hintText: "Enter the password"),
              ),
              SizedBox(height: 10.0),
              RaisedButton(
                child: Text('Login'),
                  onPressed: (){
                  if(_emailFeild.text.isEmpty || _password.text.isEmpty){
                    print('Enter email and pwd!!');
                    return;
                  }
                signInWithEmail(_emailFeild.text, _password.text);
                return;
              },
              ),
            ],
          ),
        ),
      ),

    );
  }
}

