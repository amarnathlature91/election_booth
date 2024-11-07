import 'dart:convert';

import 'package:election_booth/model/user_roles.dart';
import 'package:election_booth/resources/app_urls.dart';
import 'package:election_booth/utils/routes/named_routes.dart';
import 'package:election_booth/viewModel/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/network/app_service.dart';
import '../utils/utils.dart';

class AuthRepository {
  Future<bool> sendOtp(
      {required BuildContext context, required String mobileNumber}) async {
    var body =
        await ApiService.post('${AppUrls.sendOtp}$mobileNumber', {}, context);
    if (body.isNotEmpty) {
      if (body['message'].toString().toLowerCase().contains('success')) {
        Utils.showSuccess(context, body['message']);
        return true;
      }

      if (body['message'].toString().toLowerCase().contains('error')) {
        Utils.showError(context, body['message']);
        return false;
      }
    }
    return false;
  }

  Future<bool> verifyOtp(
      {required BuildContext context,
      required String mobile,
      required String otp}) async {
    var payload = {
      'otp': otp,
      'username': mobile,
    };
    var body = await ApiService.post(AppUrls.verifyOtp, payload, context);

    if (body.isNotEmpty) {
      if (body['message'].toString().toLowerCase().contains('success')) {
        Utils.showSuccess(context, body['message']);
        var r = Provider.of<UserProvider>(context, listen: false)
            .setUserFromJson(body);
        if (r) {
          await Utils.setUser(jsonEncode(body));
          var u = Provider.of<UserProvider>(context, listen: false).user;
          switch (u.roles[0]) {
            case Roles.ROLE_CORE_COMMITTEE:
              Navigator.pushNamedAndRemoveUntil(
                  context, NamedRoutes.coreCommittee, (_) => false);
              break;
            case Roles.ROLE_YAADI_LEADER:
              Navigator.pushNamedAndRemoveUntil(
                  context, NamedRoutes.yaadiLead, (_) => false);
              break;
            default:
              Navigator.pushNamedAndRemoveUntil(
                  context, NamedRoutes.home, (_) => false);
          }
        }
        return true;
      }

      if (body['message'].toString().toLowerCase().contains('error')) {
        Utils.showError(context, body['message']);
        return false;
      }
    }
    return false;
  }

  Future<bool> signUp({
    required BuildContext context,
    required String fName,
    required String mName,
    required String lName,
    required String mobile,
  }) async {
    var payload = {
      'firstName': fName,
      'middleName': mName,
      'lastName': lName,
      'mobNo': mobile,
    };
    var body = await ApiService.post(AppUrls.signUp, payload, context);
    if (body.isNotEmpty) {
      if (body['message'].toString().toLowerCase().contains('success')) {
        Utils.showSuccess(context, body['message']);
        return true;
      }
      if (body['message'].toString().toLowerCase().contains('error')) {
        Utils.showError(context, body['message']);
        return false;
      }
    }
    return false;
  }
}
