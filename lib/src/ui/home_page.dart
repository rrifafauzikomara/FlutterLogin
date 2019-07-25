import 'package:flutter/material.dart';
import 'package:flutter_login/src/resources/utils/shared_preferences.dart';

import 'login_page.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.lock_open),
            onPressed: () => progressLogOut(),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Text("Home"),
        ),
      ),
    );
  }

  progressLogOut() {
    setState(() {
      SessionManager().signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => Login()));
    });
  }

}
