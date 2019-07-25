import 'dart:async';
import 'package:flutter_login/src/resources/utils/login_status.dart';
import 'package:flutter_login/src/resources/utils/shared_preferences.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'package:toast/toast.dart';

class ApiProvider {

  Client client = Client();
  static final String baseUrl = 'http://192.3.168.178/restapi/';
  LoginStatus _loginStatus ;

  Future<LoginStatus> loginProvider(context, String username, String password) async {
    final response = await client.post(baseUrl + 'login.php', body: {
      "username" : username,
      "password" : password
    });

    final data = json.decode(response.body);
    String status = data['status'];
    String message = data['message'];

    if (response.statusCode == 200) {
      if (status == "success") {
        SessionManager().savePref(status);
        _loginStatus = LoginStatus.signIn;
        Toast.show(message, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      } else {
        _loginStatus = LoginStatus.notSignIn;
        Toast.show(message, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }
      return _loginStatus;
    } else {
      throw Exception('Failed');
    }
  }

  //use navigation
//  login(String username, String password, context) async {
//    final response = await client.post(baseUrl + "login.php", body: {
//      "username" : username,
//      "password" : password
//    });
//
//    final data = json.decode(response.body);
//    String status = data['status'];
//    String message = data['message'];
//    if (status == "success") {
//      Navigator.pushReplacement(
//          context,
//          MaterialPageRoute(
//              builder: (BuildContext context) => Home())
//      );
//      SessionManager().savePref(status);
//      print(message);
//    } else {
//      print(message);
//    }
//  }
}