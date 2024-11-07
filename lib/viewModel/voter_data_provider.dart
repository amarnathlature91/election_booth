import 'package:election_booth/model/voter_data.dart';
import 'package:election_booth/repository/home_repository.dart';
import 'package:flutter/material.dart';

class VoterDataProvider with ChangeNotifier {
  VoterData _voterData = VoterData(
      totalVoters: 0.0,
      remainingVoters: 0.0,
      doneVoters: 0.0,
      totalPercentage: 0.0);

  bool _isLoading = false;

  bool get loading => _isLoading;

  VoterData get voterData => _voterData;

  bool setVoterDataFromJson(Map<String, dynamic> json) {
    _voterData = VoterData.fromJson(json);
    return _voterData.totalVoters != null ? true : false;
  }

  void setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  Future<void> loadVoterData({required BuildContext context}) async {
    setLoading(true);
    HomeRepository homeRepository = HomeRepository();
    _voterData = (await homeRepository.getVoterData(context: context))!;
    setLoading(false);
  }
}
