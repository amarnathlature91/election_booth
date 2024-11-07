import 'dart:convert';

import 'package:election_booth/model/user_roles.dart';
import 'package:election_booth/utils/global_variables.dart';
import 'package:election_booth/viewModel/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static void changeFocus(
      {required BuildContext context, required FocusNode next}) {
    FocusScope.of(context).requestFocus(next);
  }

  static Future<String?> getToken() async {
    final SharedPreferences sr = await SharedPreferences.getInstance();
    return sr.getString(GlobalVariables.tokenKey);
  }

  static Future<bool> setToken(String token) async {
    final SharedPreferences sr = await SharedPreferences.getInstance();
    return sr.setString(GlobalVariables.tokenKey, token);
  }

  static Future<bool> setUser(String user) async {
    final SharedPreferences sr = await SharedPreferences.getInstance();
    return sr.setString(GlobalVariables.userKey, user);
  }

  static Future<String?> getUser() async {
    final SharedPreferences sr = await SharedPreferences.getInstance();
    return sr.getString(GlobalVariables.userKey);
  }

  static Future<bool> deleteToken() async {
    final SharedPreferences sr = await SharedPreferences.getInstance();
    sr.clear();
    return sr.setString(GlobalVariables.tokenKey, '');
  }

  static Roles hasRole({required BuildContext context}) {
    var u = Provider.of<UserProvider>(context, listen: false).user;
    return u.roles[0];
  }

  static dynamic tryDecode(String responseBody) {
    try {
      return jsonDecode(responseBody);
    } catch (e) {
      print('Error decoding JSON: $e');
      return null;
    }
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      showCloseIcon: true,
    ));
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
      showCloseIcon: true,
    ));
  }

  static void showGeneral(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      duration: const Duration(seconds: 3),
      showCloseIcon: true,
    ));
  }
}
