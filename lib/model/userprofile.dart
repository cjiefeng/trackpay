class UserProfile {
  final String _name;
  final String _email;
  final int _hour;
  final int _min;
  final double _totalAmount;

  UserProfile(this._name, this._email, this._hour, this._min, this._totalAmount);

  String getName() {
    return _name;
  }

  String getEmail() {
    return _email;
  }

  String getHours() {
    String readable_hours =  _hour.toString() + " hours";
    if (_min != 0) {
      readable_hours += " and " + _min.toString() + " min";
    }
    return readable_hours;
  }

  String getTotalAmount() {
    return _totalAmount.toStringAsFixed(2);
  }
}