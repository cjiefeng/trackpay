import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:trackpay_app/model/timesheet.dart';
import 'package:trackpay_app/model/userprofile.dart';
import 'package:uuid/uuid.dart';

class FireStore {
  static final Firestore _firestore = Firestore.instance;
  static var uuid = new Uuid();

  static Future<UserProfile> getUserData(String uid) async {
    UserProfile userProfile;

    await _firestore
        .collection("Users")
        .document(uid)
        .get()
        .then((documentSnapshot) {
          userProfile = UserProfile(documentSnapshot.data["displayName"],
              documentSnapshot.data["email"], documentSnapshot.data["hour"],
              documentSnapshot.data["min"],
              double.parse(documentSnapshot.data["amount"]));
    });

    return userProfile;
  }

  static void addUser(String uid, String name, String email) async {
    _firestore.runTransaction((Transaction transaction) async {
      CollectionReference reference = _firestore.collection('Users');
      await reference
          .document(uid)
          .setData({
        "displayName": name,
        "email": email,
        "hour": 0,
        "min": 0,
        "amount": "0.00"
      });
      print("added " + name + " to " + uid);
    });
  }

  static Future<List<TimeSheet>> getTimeSheet(String uid) async {
    List<TimeSheet> timeSheets = [];

    print(uid);

    await _firestore
        .collection("Users")
        .document(uid)
        .getCollection("TimeSheets")
        .getDocuments()
        .then((querySnapShot) {
      List ds = querySnapShot.documents;
      for (var d in ds) {
        TimeSheet timeSheet = TimeSheet(
            d.documentID,
            d.data["description"],
            d.data["start_datetime"],
            d.data["end_datetime"],
            d.data["perhour"]);
        timeSheets.add(timeSheet);
      }
    });

    timeSheets.sort((a, b) => a.compareTo(b));

    return timeSheets;
  }

  static Future<List<TimeSheet>> getTimeSheetFromTo(String uid,
      DateTime startDate, DateTime endDate) async {

    List<TimeSheet> timeSheets = [];
    print(uid);

    await _firestore
        .collection("Users")
        .document(uid)
        .getCollection("TimeSheets")
        .getDocuments()
        .then((querySnapShot) {
      List ds = querySnapShot.documents;
      for (var d in ds) {
        TimeSheet timeSheet = TimeSheet(
            d.documentID,
            d.data["description"],
            d.data["start_datetime"],
            d.data["end_datetime"],
            d.data["perhour"]);

        if (startDate.isBefore(timeSheet.startDate())
            && timeSheet.startDate().isBefore(endDate.add(Duration(days: 1)))) {
          timeSheets.add(timeSheet);
        }
      }
    });

    timeSheets.sort((a, b) => a.compareTo(b));

    return timeSheets;
  }

  static void addTimeSheet(var tsDictionary, String uid) {
    print("Writing to file");
    //pre process ts
    String description = tsDictionary["description"];

    List<int> start = [];
    start.add(int.parse(tsDictionary["startTime"].substring(0, 2)));
    start.add(int.parse(tsDictionary["startTime"].substring(2, 4)));
    DateTime startDateTime =
        tsDictionary["date"].add(Duration(hours: start[0], minutes: start[1]));

    List<int> end = [];
    end.add(int.parse(tsDictionary["endTime"].substring(0, 2)));
    end.add(int.parse(tsDictionary["endTime"].substring(2, 4)));
    DateTime endDateTime =
        tsDictionary["date"].add(Duration(hours: end[0], minutes: end[1]));
    if (startDateTime.isAfter(endDateTime)) {
      endDateTime = endDateTime.add(Duration(days: 1));
    }

    int rate = int.parse(tsDictionary["rate"]);

    print(startDateTime.toString());
    print(endDateTime.toString());

    _firestore.runTransaction((Transaction transaction) async {

      CollectionReference reference = _firestore.collection("Users");

      await reference.document(uid).getCollection("TimeSheets")
          .document(uuid.v1()).setData({
        "description": description,
        "start_datetime": startDateTime.toString(),
        "end_datetime": endDateTime.toString(),
        "perhour": rate
      });
      print("added " +
          uid +
          " " +
          description +
          " " +
          startDateTime.toString() +
          " " +
          endDateTime.toString() +
          " " +
          rate.toString());

      int currHour;
      int currMin;
      double amount;
      await _firestore
          .collection("Users")
          .document(uid)
          .get()
          .then((documentSnapshot) {
        currHour = documentSnapshot.data["hour"];
        currMin = documentSnapshot.data["min"];
        amount = double.parse(documentSnapshot.data["amount"]);
      });

      TimeSheet ts = TimeSheet("", description, startDateTime.toString(),
          endDateTime.toString(), rate);

      Duration currDuration = Duration(hours: currHour, minutes: currMin);
      Duration difference = ts.getDiff();
      currDuration = currDuration + difference;

      await transaction.update(reference.document(uid), {
        "hour" : currDuration.inHours,
        "min" : currDuration.inMinutes - currDuration.inHours * 60,
        "amount": (amount + ts.getTotalAmountDouble()).toString()
      });

    });
  }

  static void deleteTimeSheet(String uid, TimeSheet ts) {
    _firestore.runTransaction((transaction) async {
      CollectionReference reference = _firestore.collection("Users");

      reference
          .document(uid)
          .getCollection("TimeSheets")
          .document(ts.getDid())
          .delete();

      int currHour;
      int currMin;
      double amount;
      await _firestore
          .collection("Users")
          .document(uid)
          .get()
          .then((documentSnapshot) {
        currHour = documentSnapshot.data["hour"];
        currMin = documentSnapshot.data["min"];
        amount = double.parse(documentSnapshot.data["amount"]);
      });

      Duration currDuration = Duration(hours: currHour, minutes: currMin);
      Duration difference = ts.getDiff();
      currDuration = currDuration - difference;

      await transaction.update(reference.document(uid), {
        "hour" : currDuration.inHours,
        "min" : currDuration.inMinutes - currDuration.inHours * 60,
        "amount": (amount - ts.getTotalAmountDouble()).toString()
      });
    });
  }
}
