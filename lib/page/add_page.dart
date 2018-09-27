import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:trackpay_app/data/auth.dart';
import 'package:trackpay_app/data/firestore.dart';

class AddPage extends StatefulWidget {
  AddPage({this.auth, this.onAdd});
  final BaseAuth auth;
  final VoidCallback onAdd;

  @override
  State<StatefulWidget> createState() => new AddPageState();
}

class AddPageState extends State<AddPage> {
  final _formKey = new GlobalKey<FormState>();
  final TextEditingController _controller = new TextEditingController();
  DateTime dateFormat;

  var tsDictionary = {};

  Future _chooseDate(BuildContext context, String initialDateString) async {
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

    setState(() {
      dateFormat = result;
      _controller.text = new DateFormat.yMd().format(result);
    });
  }

  DateTime convertToDate(String input) {
    try {
      var d = new DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  bool isValidTime(String input) {
    final RegExp regex1 = new RegExp(r"^[0-1][0-9][0-5][0-9]$");
    final RegExp regex2 = new RegExp(r"^[2][0-3][0-5][0-9]$");
    return regex1.hasMatch(input) || regex2.hasMatch(input);
  }

  bool isValidAmount(String input) {
    final RegExp regex = new RegExp(r"^\d+$");
    return regex.hasMatch(input);
  }

  void _submitForm() async {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Oops, something wrong with the details');
    } else {
      form.save();

      String uid = await widget.auth.currentUserId();
      FireStore.addTimeSheet(tsDictionary, uid);

      print('Form saved, new record added.');
      print('Description: ${tsDictionary["description"]}');
      print('Date: ${tsDictionary["date"].toString()}');
      print('Start Time: ${tsDictionary["startTime"]}');
      print('End Time: ${tsDictionary["endTime"]}');
      print('Rate: ${tsDictionary["rate"]}');
      widget.onAdd();
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
                  new TextFormField(
                    decoration: new InputDecoration(
                      labelText: 'Description',
                      hintText: 'low paid lousy ass job',
                      icon: const Icon(Icons.work, color: Colors.black),
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'Description can\'t be empty' : null,
                    onSaved: (value) => tsDictionary["description"] = value,
                  ),
                  new Row(children: <Widget>[
                    new Expanded(
                        child: new TextFormField(
                      enabled: false,
                      decoration: new InputDecoration(
                        icon: const Icon(Icons.calendar_today),
                        labelText: 'Date',
                      ),
                      validator: (value) =>
                          value.isEmpty ? 'Date can\'t be empty' : null,
                      onSaved: (value) => tsDictionary["date"] = dateFormat,
                      controller: _controller,
                      keyboardType: TextInputType.datetime,
                    )),
                    new IconButton(
                      icon: new Icon(Icons.more_horiz),
                      tooltip: 'Choose date',
                      onPressed: (() {
                        _chooseDate(context, _controller.text);
                      }),
                    )
                  ]),
                  new TextFormField(
                    decoration: new InputDecoration(
                      labelText: 'Start time',
                      hintText: '0000',
                      icon: const Icon(Icons.mood_bad, color: Colors.black),
                    ),
                    validator: (value) =>
                        isValidTime(value) ? null : 'Invalid Start time',
                    onSaved: (value) => tsDictionary["startTime"] = value,
                    keyboardType: TextInputType.number,
                  ),
                  new TextFormField(
                    decoration: new InputDecoration(
                      labelText: 'End time',
                      hintText: '0000',
                      icon: const Icon(Icons.mood, color: Colors.black),
                    ),
                    validator: (value) =>
                        isValidTime(value) ? null : 'Invalid End time',
                    onSaved: (value) => tsDictionary["endTime"] = value,
                    keyboardType: TextInputType.number,
                  ),
                  new TextFormField(
                    decoration: new InputDecoration(
                      labelText: 'Rate',
                      hintText: '10',
                      icon: const Icon(Icons.attach_money, color: Colors.black),
                    ),
                    validator: (value) =>
                        isValidAmount(value) ? null : 'Invalid Rate',
                    onSaved: (value) => tsDictionary["rate"] = value,
                    keyboardType: TextInputType.number,
                  ),
                  new Container(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: new RaisedButton(
                          child: Text("Add"), onPressed: _submitForm))
                ])));
  }
}
