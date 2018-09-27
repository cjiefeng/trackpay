import 'package:flutter/material.dart';
import 'package:trackpay_app/model/timesheet.dart';
import 'package:trackpay_app/data/firestore.dart';
import 'package:trackpay_app/data/auth.dart';

class TimesheetPage extends StatefulWidget {
  TimesheetPage(this.auth, this.ts, this.onDelete);
  final BaseAuth auth;
  final TimeSheet ts;
  final VoidCallback onDelete;

  @override
  State<StatefulWidget> createState() => new TimeSheetPageState();
}

class TimeSheetPageState extends State<TimesheetPage> {
  void _showAlert() {
    AlertDialog dialog = new AlertDialog(
        title: new Text("Are you sure you want to delete?"),
        actions: <Widget>[
          RaisedButton(
              textColor: Colors.redAccent,
              onPressed: _deleteRecord,
              child: new Text("Yes")),
          RaisedButton(
              textColor: Colors.black,
              onPressed: _getBack,
              child: new Text("No")),
        ]);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  void _getBack() {
    Navigator.pop(context);
  }

  void _deleteRecord() async {
    String uid = await widget.auth.currentUserId();
    FireStore.deleteTimeSheet(uid, widget.ts);
    widget.onDelete();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.ts.getStartDate()),
        ),
        body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              new ListTile(
                  title: Row(children: <Widget>[
                new Expanded(child: new Text("Description: ")),
                new Expanded(child: new Text(widget.ts.getDescription())),
              ])),
              new ListTile(
                  title: Row(children: <Widget>[
                new Expanded(child: new Text("Started at: ")),
                new Expanded(
                    child: new Text(widget.ts.getStartDate() +
                        ", " +
                        widget.ts.getStartTime())),
              ])),
              new ListTile(
                  title: Row(children: <Widget>[
                new Expanded(child: new Text("Ended at: ")),
                new Expanded(
                    child: new Text(widget.ts.getEndDate() +
                        ", " +
                        widget.ts.getEndTime())),
              ])),
              new ListTile(
                  title: Row(children: <Widget>[
                new Expanded(child: new Text("Hours: ")),
                new Expanded(child: new Text(widget.ts.getHours())),
              ])),
              new ListTile(
                  title: Row(children: <Widget>[
                new Expanded(child: new Text("Rate: ")),
                new Expanded(
                    child: new Text("\$" + widget.ts.getRate() + "/hour")),
              ])),
              new ListTile(
                  title: Row(children: <Widget>[
                new Expanded(child: new Text("Amount: ")),
                new Expanded(
                    child: new Text("\$" + widget.ts.getTotalAmount())),
              ])),
              new RaisedButton(
                child: new Text('Delete Record',
                    style: new TextStyle(color: Colors.redAccent)),
                onPressed: _showAlert,
              ),
            ]));
  }
}
