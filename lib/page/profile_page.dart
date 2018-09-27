import 'package:flutter/material.dart';
import 'package:trackpay_app/data/auth.dart';
import 'package:trackpay_app/data/firestore.dart';
import 'dart:async';
import 'package:trackpay_app/model/userprofile.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => new ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  void _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  Future<UserProfile> _getUserData() async {
    UserProfile userProfile;
    await widget.auth.currentUserId().then((uid) async {
      userProfile = await FireStore.getUserData(uid);
    });

    return userProfile;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new Center(
            child: new FutureBuilder(
                future: _getUserData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(child: Center(child: Text("Loading...")));
                  } else {
                    UserProfile userProfile = snapshot.data;
                    return ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        children: <Widget>[
                          new ListTile(
                              title:
                                  Text("Hi, " + userProfile.getName() + "!")),
                          new ListTile(
                              title: Text(
                                  "Congratulations, you have worked for \n" +
                                      userProfile.getHours() +
                                      " and earned \$" +
                                      userProfile.getTotalAmount() +
                                      "!")),
                          new ListTile(
                            title: Text("Email"),
                            subtitle: Text(userProfile.getEmail()),
                          ),
                          new ListTile(
                              title: RaisedButton(
                            child: Text("Logout"),
                            onPressed: _signOut,
                          )),
                        ]);
                  }
                })));
  }
}
