import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:trackpay_app/model/timesheet.dart';
import 'package:uuid/uuid.dart';

//deleting file. reference only

class ReadWriteJSON {
  static File jsonFile;
  static Directory dir;
  static String fileName = "myJSONFile.json";
  static String filePath;
  static bool fileExists = false;
  static var uuid = new Uuid();

  static Future<List<TimeSheet>> getTimeSheet() async {
    List<TimeSheet> timeSheets = [];
    var jsonData = json.decode(jsonFile.readAsStringSync());

    for (var ts in jsonData) {
      TimeSheet timeSheet = TimeSheet(ts["did"], ts["description"],
          ts["start_datetime"], ts["end_datetime"], ts["perhour"]);
      timeSheets.add(timeSheet);
    }
    print(jsonData);
    print("number of records: " + timeSheets.length.toString());
    timeSheets.sort((a, b) => a.compareTo(b));

    return timeSheets;
  }

  static void createFile() {
    if (!fileExists) {
      print("Creating file");
      File file = new File(filePath);
      file.createSync();
      fileExists = true;
    } else {
      print("File exists!");
    }
  }

  static writeToFile(var tsDictionary) {
    print("Writing to file");
    if (fileExists) {
      //pre process ts
      String description = tsDictionary["description"];

      List<int> start = [];
      start.add(int.parse(tsDictionary["startTime"].substring(0, 2)));
      start.add(int.parse(tsDictionary["startTime"].substring(2, 4)));
      DateTime startDateTime = tsDictionary["date"]
          .add(Duration(hours: start[0], minutes: start[1]));

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

      var jsonFileContent = json.decode(jsonFile.readAsStringSync());
      var content = {
        "uuid": uuid.v1(),
        "description": description,
        "start_datetime": startDateTime.toString(),
        "end_datetime": endDateTime.toString(),
        "perhour": rate
      };
      print(content);
      jsonFileContent.add(content);
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    } else {
      print("File does not exist");
      createFile();
    }
  }

  /*
  static initFile() {
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      filePath = dir.path + "/" + fileName;
      jsonFile = new File(filePath);
      fileExists = jsonFile.existsSync();
    });
    createFile();
  }
  */

  static bool first = true;
  static void populateFile() {
    if (first) {
      print("killed and respawned");
      //initFile();
      var data = [
        {
          "uuid": uuid.v1(),
          "description": 'lumina',
          "start_datetime": "20180919 183000",
          "end_datetime": "20180920 000000",
          "perhour": 10
        },
        {
          "uuid": uuid.v1(),
          "description": "lumina",
          "start_datetime": "20180920 180000",
          "end_datetime": "20180921 000000",
          "perhour": 10
        },
        {
          "uuid": uuid.v1(),
          "description": "lumina",
          "start_datetime": "20180921 180000",
          "end_datetime": "20180922 000000",
          "perhour": 10
        },
        {
          "uuid": uuid.v1(),
          "description": "lumina",
          "start_datetime": "20180922 180000",
          "end_datetime": "20180922 223000",
          "perhour": 10
        }
      ];
      jsonFile.writeAsStringSync(json.encode(data));
      first = false;
    }
  }
}
