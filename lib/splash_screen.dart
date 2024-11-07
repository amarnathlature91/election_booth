import 'dart:convert';

import 'package:election_booth/model/user.dart';
import 'package:election_booth/utils/routes/named_routes.dart';
import 'package:election_booth/utils/utils.dart';
import 'package:election_booth/viewModel/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';

import 'model/user_roles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkAndNavigate();
    super.initState();
  }

  checkAndNavigate() async {
    var rawUser = await Utils.getUser();
    if (rawUser != null && rawUser.isNotEmpty) {
      var u = User.fromJson(jsonDecode(rawUser));
      print(u.token);
      Provider.of<UserProvider>(context, listen: false).setUserFromModel(u);
      if (JwtDecoder.isExpired(u.token!)) {
        Utils.showError(context, 'Session Expired');
        Navigator.pushNamedAndRemoveUntil(
            context, NamedRoutes.sendOtp, (_) => false);
      } else {
        print(u.roles);
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
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, NamedRoutes.sendOtp, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Center(child: CircularProgressIndicator())],
      ),
    );
  }
}
