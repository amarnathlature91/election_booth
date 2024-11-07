import 'package:election_booth/resources/app_urls.dart';
import 'package:flutter/cupertino.dart';

import '../data/network/app_service.dart';
import '../model/voter.dart';

class VoterListRepository {
  Future<List<Voter>> getVoterList({
    required BuildContext context,
    required int pageNo,
    required String searchText,
    required String votedOrNot,
  }) async {
    print(
        '${AppUrls.getVoters}?limit=15&pageNo=$pageNo&searchText=$searchText&votedOrNot=$votedOrNot');
    var body = await ApiService.get(
        '${AppUrls.getVoters}?limit=15&pageNo=$pageNo&searchText=$searchText&votedOrNot=$votedOrNot',
        context);
    List<Voter> vl = [];
    if (body.isNotEmpty) {
      body.forEach((v) {
        vl.add(Voter.fromJson(v));
      });
    }
    return vl;
  }

  Future<void> updateVoted(
      {required BuildContext context, required int id}) async {
    var body = await ApiService.put('${AppUrls.updateVoted}$id', null, context);
    if (body.isNotEmpty) {}
  }
}
