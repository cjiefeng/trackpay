import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:trackpay_app/data/auth.dart';
import 'home_page.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus { notSignedIn, signedIn }

class _RootPageState extends State<RootPage> {
  AuthStatus _authStatus = AuthStatus.notSignedIn;

  void initState() {
    super.initState();
    widget.auth.currentUserId().then((userId) {
      setState(() {
        _authStatus =
            userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      _authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_authStatus == AuthStatus.signedIn) {
      return new HomePage(
        auth: widget.auth,
        onSignedOut: _signedOut,
      );
    } else {
      return new LoginPage(
        auth: widget.auth,
        onSignedin: _signedIn,
      );
    }
  }
}
