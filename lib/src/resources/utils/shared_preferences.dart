import 'package:shared_preferences/shared_preferences.dart';

import 'login_status.dart';

class SessionManager {

  //use navigator
//    savePref(String status) async {
//    SharedPreferences preferences = await SharedPreferences.getInstance();
//    preferences.setString("status", status);
//  }
//
//  getPref(context) async {
//    SharedPreferences preferences = await SharedPreferences.getInstance();
//    status = preferences.getString("status");
//    if (status == "success") {
//      Navigator.pushReplacement(
//          context,
//          MaterialPageRoute(
//              builder: (BuildContext context) => Home())
//      );
//    } else {
//      Navigator.pushReplacement(
//          context,
//          MaterialPageRoute(
//              builder: (BuildContext context) => Login())
//      );
//    }
//  }
//
//  signOut(context) async {
//    SharedPreferences preferences = await SharedPreferences.getInstance();
//    preferences.setString("status", null);
//    Navigator.pushReplacement(
//        context,
//        MaterialPageRoute(
//            builder: (BuildContext context) => Login())
//    );
//  }

  savePref(String status) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("status", status);
  }

  LoginStatus _loginStatus = LoginStatus.notSignIn;
  Future<LoginStatus> getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.getString("status") == "success"){
      _loginStatus = LoginStatus.signIn;
    } else {
      _loginStatus = LoginStatus.notSignIn;
    }
    return _loginStatus;
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("status", null);
  }
}