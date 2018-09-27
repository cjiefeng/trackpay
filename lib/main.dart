import 'package:flutter/material.dart';
import 'package:trackpay_app/data/auth.dart';
import 'package:trackpay_app/page/root_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'TrackPay',
        theme: new ThemeData(
          primaryColor: Colors.white,
          accentColor: Colors.grey,
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: new TextStyle(color: Colors.black),
          ),
        ),
        home: new RootPage(auth: new Auth()));
  }
}

