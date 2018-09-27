import 'package:flutter/material.dart';
import 'package:trackpay_app/data/auth.dart';
import 'list_page.dart';
import 'add_page.dart';
import 'generate_report_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  int _bottomNavBarIndex = 0;

  void _deleted() {
    setState(() {
      _bottomNavBarIndex = 0;
    });
  }

  void _added() {
    setState(() {
      print("here?");
      _bottomNavBarIndex = 0;
    });
  }

  Widget buildBody(int index) {
    var pages = [
      new ListPage(
        auth: widget.auth,
        onDelete: _deleted,
      ),
      new AddPage(
        auth: widget.auth,
        onAdd: _added
      ),
      new GenerateReportPage(auth: widget.auth),
      new ProfilePage(
          auth: widget.auth,
          onSignedOut: _signOut
      ),
    ];
    return pages[index];
  }

  void _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: titleText(),
      ),
      body: buildBody(_bottomNavBarIndex),
      bottomNavigationBar: new BottomNavigationBar(
        iconSize: 30.0,
        //type: BottomNavigationBarType.fixed,
        currentIndex: _bottomNavBarIndex,
        onTap: (int index) {
          setState(() {
            _bottomNavBarIndex = index;
          });
        },
        items: [
          new BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.black),
              title: Container(height: 0.0)),
          new BottomNavigationBarItem(
              icon: Icon(Icons.add, color: Colors.black),
              title: Container(height: 0.0)),
          new BottomNavigationBarItem(
              icon: Icon(Icons.show_chart, color: Colors.black),
              title: Container(height: 0.0)),
          new BottomNavigationBarItem(
              icon: Icon(Icons.account_circle, color: Colors.black),
              title: Container(height: 0.0))
        ],
      ),
    );
  }

  Widget titleText() {
    if (_bottomNavBarIndex == 0) {
      return new Text("Home");
    } else if (_bottomNavBarIndex == 1) {
      return new Text("Add");
    } else if (_bottomNavBarIndex == 2) {
      return new Text("Generate Report");
    } else if (_bottomNavBarIndex == 3) {
      return new Text("Profile");
    }
    return new Text("");
  }
}
