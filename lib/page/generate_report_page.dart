import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackpay_app/data/auth.dart';
import 'package:trackpay_app/page/report_detail.dart';
import 'dart:async';

class GenerateReportPage extends StatefulWidget {
  GenerateReportPage({this.auth});
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new GenerateReportPageState();
}

class GenerateReportPageState extends State<GenerateReportPage> {
  final _formKey = new GlobalKey<FormState>();
  final TextEditingController _controller1 = new TextEditingController();
  final TextEditingController _controller2 = new TextEditingController();
  DateTime dateFormat1;
  DateTime dateFormat2;

  var dateDictionary = {};

  Future _chooseDate(BuildContext context, String initialDateString, int i) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now());

    if (result == null) return;

    if (i == 1) {
      setState(() {
        dateFormat1 = result;
        _controller1.text = new DateFormat.yMd().format(result);
      });
    } else {
      setState(() {
        dateFormat2 = result;
        _controller2.text = new DateFormat.yMd().format(result);
      });
    }
  }

  DateTime convertToDate(String input) {
    try {
      var d = new DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  void _submitForm() async {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Proper date mate');
    } else {
      form.save();

      print('Form saved.');
      print('Date: ${dateDictionary["startDate"].toString()}');
      print('Date: ${dateDictionary["endDate"].toString()}');

      if (dateDictionary["startDate"].isAfter(dateDictionary["endDate"])) {
        print('Start date is after end date');
        showMessage('Start cannot be before end, mate');
      } else {
        print('Ok retrieving data');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              ReportDetailPage(widget.auth, dateDictionary)),
        );
      }
    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    Scaffold.of(context).showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  Widget build(BuildContext context) {
    return Container(
        child: new Form(
            key: _formKey,
            autovalidate: true,
            child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new Row(children: <Widget>[
                    new Expanded(
                        child: new TextFormField(
                          enabled: false,
                          decoration: new InputDecoration(
                            icon: const Icon(Icons.calendar_today),
                            labelText: 'From Date',
                          ),
                          validator: (value) =>
                          value.isEmpty ? 'Date can\'t be empty' : null,
                          onSaved: (value) => dateDictionary["startDate"] = dateFormat1,
                          controller: _controller1,
                          keyboardType: TextInputType.datetime,
                        )),
                    new IconButton(
                      icon: new Icon(Icons.more_horiz),
                      tooltip: 'From date',
                      onPressed: (() {
                        _chooseDate(context, _controller1.text, 1);
                      }),
                    )
                  ]),
                  new Row(children: <Widget>[
                    new Expanded(
                        child: new TextFormField(
                          enabled: false,
                          decoration: new InputDecoration(
                            icon: const Icon(Icons.calendar_today),
                            labelText: 'To date',
                          ),
                          validator: (value) =>
                          value.isEmpty ? 'Date can\'t be empty' : null,
                          onSaved: (value) => dateDictionary["endDate"] = dateFormat2,
                          controller: _controller2,
                          keyboardType: TextInputType.datetime,
                        )),
                    new IconButton(
                      icon: new Icon(Icons.more_horiz),
                      tooltip: 'Choose date',
                      onPressed: (() {
                        _chooseDate(context, _controller2.text, 2);
                      }),
                    )
                  ]),
                  new Container(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: new RaisedButton(
                          child: const Text("Generate"), onPressed: _submitForm))
                ])));
  }
}