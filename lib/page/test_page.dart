import 'package:flutter/material.dart';
import 'package:trackpay_app/data/auth.dart';
import 'package:trackpay_app/data/firestore.dart';

class TestPage extends StatefulWidget {
  TestPage({this.auth});
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new TestPageState();
}

class TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new Center(
            child: new FutureBuilder(
                future: widget.auth.currentUserId(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(child: Center(child: Text("Loading...")));
                  } else {
                    return ListView(children: [
                      Center(child: Text(snapshot.data.toString())),
                      Container(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: new RaisedButton(
                              child: const Text("Add"),
                              onPressed: () {
                                FireStore
                                    .getTimeSheet(snapshot.data.toString());
                              }))
                    ]);
                  }
                })));
  }
}
