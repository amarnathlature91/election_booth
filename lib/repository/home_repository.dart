import 'package:election_booth/model/voter_data.dart';
import 'package:flutter/material.dart';

import '../data/network/app_service.dart';
import '../resources/app_urls.dart';
import '../utils/utils.dart';

class HomeRepository {
  Future<VoterData?> getVoterData({required BuildContext context}) async {
    var body = await ApiService.get(AppUrls.getVoterData, context);

    if (body.isNotEmpty) {
      if (body['totalVoters'] != null) {
        return VoterData.fromJson(body);
      }

      if (body['message'].toString().toLowerCase().contains('success')) {
        Utils.showSuccess(context, body['message']);
      }

      if (body['message'].toString().toLowerCase().contains('error')) {
        Utils.showError(context, body['message']);
      }
    }
    return null;
  }

  Future<VoterData?> getVoterDataCoreCommittee(
      {required BuildContext context}) async {
    var body = await ApiService.get(AppUrls.getVoterData, context);

    if (body.isNotEmpty) {
      if (body['totalVoters'] != null) {
        return VoterData.fromJson(body);
      }

      if (body['message'].toString().toLowerCase().contains('success')) {
        Utils.showSuccess(context, body['message']);
      }

      if (body['message'].toString().toLowerCase().contains('error')) {
        Utils.showError(context, body['message']);
      }
    }
    return null;
  }
}
