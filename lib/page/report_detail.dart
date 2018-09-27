import 'package:flutter/material.dart';
import 'package:trackpay_app/model/timesheet.dart';
import 'package:trackpay_app/data/auth.dart';
import 'package:trackpay_app/data/firestore.dart';
import 'dart:async';
import 'timesheet_page.dart';

class ReportDetailPage extends StatefulWidget {
  ReportDetailPage(this.auth, this.dateDictionary);
  final BaseAuth auth;
  final dateDictionary;

  @override
  State<StatefulWidget> createState() => new ReportDetailPageState();
}

class ReportDetailPageState extends State<ReportDetailPage> {

  void _deleted() {
    setState(() {});
  }

  Future<List<TimeSheet>> getTimeSheet() async {
    String uid = await widget.auth.currentUserId();
    DateTime startDate = widget.dateDictionary["startDate"];
    DateTime endDate = widget.dateDictionary["endDate"];
    return FireStore.getTimeSheetFromTo(uid, startDate, endDate);
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
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Report"),
        ),
        body: Container(
            child: new Center(
                child: new FutureBuilder(
          future: getTimeSheet(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(child: Center(child: Text("Loading...")));
            } else {
              return new ListView.builder(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  itemCount: snapshot.data.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      double subtotal = 0.00;
                      for (TimeSheet ts in snapshot.data) {
                        subtotal += ts.getTotalAmountDouble();
                      }
                      return new ListTile(
                        isThreeLine: false,
                        title: new Center(
                            child: Text(
                                "Subtotal: \$" + subtotal.toStringAsFixed(2),
                                style: new TextStyle(fontSize: 24.0))),
                      );
                    } else {
                      TimeSheet ts = snapshot.data[index - 1];
                      return new ListTile(
                        isThreeLine: false,
                        title: Text(ts.getStartDate()),
                        subtitle:
                            Text(ts.getStartTime() + " - " + ts.getEndTime()),
                        trailing: Text("\$" + ts.getTotalAmount(),
                            style: new TextStyle(fontSize: 20.0)),
                        onTap: () {
                          goTimeSheetPage(ts);
                        },
                      );
                    }
                  });
            }
          },
        ))));
  }
}
