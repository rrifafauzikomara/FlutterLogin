import 'package:flutter/material.dart';
import 'package:flutter_login/src/common/loading_indicator.dart';
import 'package:flutter_login/src/custom/clipper.dart';
import 'package:flutter_login/src/resources/api/api_provider.dart';
import 'package:flutter_login/src/resources/utils/login_status.dart';
import 'package:flutter_login/src/resources/utils/shared_preferences.dart';

import 'home_page.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String username, password;
  final _key = GlobalKey<FormState>();
  bool _secureText = true;
  bool isProcessing = false;

  showHidePassword() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  showLoading() {
    setState(() {
      isProcessing = true;
    });
  }

  hiddenLoading() {
    setState(() {
      isProcessing = false;
    });
  }

  loginValidate() {
    final form = _key.currentState;
    if(form.validate()) {
      form.save();
      ApiProvider().loginProvider(context, username, password).then((value){
        setState(() {
          _loginStatus = value;
          isProcessing = false;
        });
      });
    } else {
      hiddenLoading();
    }
  }

  loginProcess() {
    showLoading();
    loginValidate();
  }

  @override
  void initState() {
    super.initState();
    SessionManager().getPref().then((value){
      setState(() {
        _loginStatus = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          backgroundColor: Colors.white,
          body: Form(
            key: _key,
            child: SafeArea(
              child: ListView(
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  ClipPath(
                    clipper: MyClipper(),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage('https://raw.githubusercontent.com/samarthagarwal/FlutterScreens/master/assets/images/full-bloom.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 150.0, bottom: 100.0),
                    ),
                  ),
                  formCardLogin(),
                  Container(
                    padding: EdgeInsets.only(right: 20.0, left: 20.0),
                    margin: EdgeInsets.only(top: 40.0),
                    child: isProcessing ? LoadingIndicator() : loginButton(),
                  ),
                ],
              ),
            ),
          ),
        );
        break;
      case LoginStatus.signIn:
        hiddenLoading();
        return Home();
        break;
    }
    return null;
  }

  Widget formCardLogin() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0, bottom: 10.0),
            alignment: Alignment.centerLeft,
            child: Text(
              "Username",
              style: TextStyle(color: Colors.grey, fontSize: 16.0),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 20.0, left: 20.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.5),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  height: 30.0,
                  width: 1.0,
                  color: Colors.grey.withOpacity(0.5),
                  margin: EdgeInsets.only(left: 00.0, right: 10.0),
                ),
                Flexible(
                  child: TextFormField(
                    validator: (e) {
                      if(e.isEmpty) {
                        return "Please Insert Username";
                      }
                    },
                    onSaved: (e) => username = e,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0, right: 20.0, left: 20.0, bottom: 10.0),
            alignment: Alignment.centerLeft,
            child: Text(
              "Password",
              style: TextStyle(color: Colors.grey, fontSize: 16.0),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 20.0, left: 20.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.5),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  child: Icon(
                    Icons.lock_open,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  height: 30.0,
                  width: 1.0,
                  color: Colors.grey.withOpacity(0.5),
                  margin: EdgeInsets.only(left: 00.0, right: 10.0),
                ),
                Flexible(
                  child: TextFormField(
                    validator: (e) {
                      if(e.isEmpty) {
                        return "Please Insert Password";
                      }
                    },
                    obscureText: _secureText,
                    onSaved: (e) => password = e,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                          icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility),
                          onPressed: showHidePassword
                      ),
                      hintText: 'Enter your password',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget loginButton() {
    return Column(
      children: <Widget>[
        GestureDetector(
          child: DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                color: Colors.blue
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    "LOGIN",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Transform.translate(
                  offset: Offset(15.0, 0.0),
                  child: Container(
                    margin: EdgeInsets.only(right: 20.0),
                    padding: EdgeInsets.all(10.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(28.0)),
                          color: Colors.white
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          onTap: () {
            loginProcess();
          },
        ),
      ],
    );
  }

}