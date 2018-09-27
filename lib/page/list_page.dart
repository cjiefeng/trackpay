import 'package:flutter/material.dart';
import 'package:trackpay_app/model/timesheet.dart';
import 'package:trackpay_app/data/auth.dart';
import 'package:trackpay_app/data/firestore.dart';
import 'timesheet_page.dart';
import 'dart:async';

class ListPage extends StatefulWidget {
  ListPage({this.auth, this.onDelete});
  final BaseAuth auth;
  final VoidCallback onDelete;

  @override
  State<StatefulWidget> createState() => new ListPageState();
}

class ListPageState extends State<ListPage> {

  void _deleted() {
    setState(() {
      widget.onDelete();
    });
  }

  Future<List<TimeSheet>> getTimeSheet() async {
    String uid = await widget.auth.currentUserId();
    return FireStore.getTimeSheet(uid);
  }

  void goTimeSheetPage(TimeSheet ts) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          TimesheetPage(widget.auth, ts, _deleted)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: new Center(
            child: new FutureBuilder(
      future: getTimeSheet(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Container(child: Center(child: Text("Loading...")));
        } else if (snapshot.data.length == 0) {
          return Container(child: Center(child: Text("Get your ass to work, potato.")));
        } else {
          return new ListView.builder(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                TimeSheet ts = snapshot.data[index];
                return new ListTile(
                  isThreeLine: false,
                  title: Text(ts.getStartDate()),
                  subtitle: Text(ts.getStartTime() + " - " + ts.getEndTime()),
                  trailing: Text("\$" + ts.getTotalAmount(),
                      style: new TextStyle(fontSize: 20.0)),
                  onTap: () {
                    goTimeSheetPage(ts);
                  },
                );
              });
        }
      },
    )));
  }
}
