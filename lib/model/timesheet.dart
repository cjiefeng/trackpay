class TimeSheet {
  final String _did;
  final String _description;
  final DateTime _startDatetime;
  final DateTime _endDatetime;
  final int _perHour;
  final Duration _diff;
  final double _totalAmount;

  static const int offset = -1;
  static const List months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  TimeSheet._(this._did, this._description, this._startDatetime,
      this._endDatetime, this._perHour, this._diff, this._totalAmount);

  factory TimeSheet(String did, String description, String startDatetime,
      String endDatetime, int perHour) {
    DateTime start = DateTime.parse(startDatetime);
    DateTime end = DateTime.parse(endDatetime);
    Duration diff = start.difference(end).abs();
    double d_hours = diff.inHours.toDouble();
    double d_mins = (diff.inMinutes - (d_hours * 60)) / 60;
    double totalAmount = (d_hours + d_mins) * perHour;

    return new TimeSheet._(
        did, description, start, end, perHour, diff, totalAmount);
  }

  String getDid() {
    return _did;
  }

  String getDescription() {
    return _description;
  }

  DateTime startDate() {
    return _startDatetime;
  }

  String getStartDate() {
    return _readableDate(_startDatetime);
  }

  String getStartTime() {
    return _readableTime(_startDatetime);
  }

  String getEndDate() {
    return _readableDate(_endDatetime);
  }

  String getEndTime() {
    return _readableTime(_endDatetime);
  }

  String getRate() {
    return _perHour.toString();
  }

  Duration getDiff() {
    return _diff;
  }

  String getHours() {
    int d_hours = _diff.inHours;
    int d_mins = _diff.inMinutes - (d_hours * 60);
    String readable_hours =  d_hours.toString() + " hours";
    if (d_mins != 0) {
      readable_hours += ", " + d_mins.toString() + " min";
    }
    return readable_hours;
  }

  String getTotalAmount() {
    return _totalAmount.toStringAsFixed(2);
  }

  double getTotalAmountDouble() {
    return _totalAmount;
  }

  String _readableDate(DateTime datetime) {
    String readableString = datetime.day.toString() +
        " " +
        months[datetime.month + offset] +
        " " +
        datetime.year.toString();

    return readableString;
  }

  String _readableTime(DateTime datetime) {
    return datetime.hour.toString().padLeft(2, '0') +
        ":" +
        datetime.minute.toString().padLeft(2, '0');
  }

  int compareTo(TimeSheet other) {
    return other.startDate().compareTo(this._startDatetime);
  }
}
