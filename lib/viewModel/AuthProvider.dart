import 'package:election_booth/repository/auth_repository.dart';
import 'package:election_booth/utils/routes/named_routes.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class AuthProvider with ChangeNotifier {
  AuthRepository authRepository = AuthRepository();

  bool _isLoading = false;

  bool get loading => _isLoading;

  setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<bool> sendOtp(
      {required BuildContext context, required String mobileNumber}) async {
    setLoading(true);
    var res = await authRepository.sendOtp(
        context: context, mobileNumber: mobileNumber);
    setLoading(false);
    return res;
  }

  Future<bool> verifyOtp(
      {required BuildContext context,
      required String mobileNumber,
      required String otp}) async {
    setLoading(true);
    var res = await authRepository.verifyOtp(
        context: context, mobile: mobileNumber, otp: otp);
    setLoading(false);
    return res;
  }

  Future<bool> signUp({
    required BuildContext context,
    required String firstName,
    required String middleName,
    required String lastname,
    required String mobileNumber,
  }) async {
    setLoading(true);
    var res = await authRepository.signUp(
        context: context,
        fName: firstName,
        mName: middleName,
        lName: lastname,
        mobile: mobileNumber);
    setLoading(false);
    if (res) {
      Navigator.pushNamedAndRemoveUntil(
          context, NamedRoutes.sendOtp, (_) => false);
    }
    return res;
  }

  Future<void> logout({required BuildContext context}) async {
    setLoading(true);

    Utils.setUser('');
    await Future.delayed(const Duration(seconds: 2), () {});
    Navigator.pushNamedAndRemoveUntil(
        context, NamedRoutes.sendOtp, (_) => false);
    setLoading(false);
  }
}
