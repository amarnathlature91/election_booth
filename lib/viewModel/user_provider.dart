import 'package:election_booth/model/user.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User _user = User();

  User get user => _user;

  bool setUserFromJson(Map<String, dynamic> json) {
    _user = User.fromJson(json);
    notifyListeners();
    return _user.id != null ? true : false;
  }

  bool setUserFromModel(User model) {
    _user = model;
    notifyListeners();
    return _user.id != null ? true : false;
  }
}
