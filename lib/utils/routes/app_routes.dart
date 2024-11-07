import 'package:election_booth/splash_screen.dart';
import 'package:election_booth/utils/routes/named_routes.dart';
import 'package:election_booth/view/auth/login_screen.dart';
import 'package:election_booth/view/auth/send_otp_screen.dart';
import 'package:election_booth/view/auth/signup_screen.dart';
import 'package:election_booth/view/core_commitee_home.dart';
import 'package:election_booth/view/home_screen.dart';
import 'package:election_booth/view/prabhag_screen.dart';
import 'package:election_booth/view/voter_detail_screen.dart';
import 'package:election_booth/view/voter_list_by_bhag.dart';
import 'package:election_booth/view/voter_list_screen.dart';
import 'package:election_booth/view/yaadi_lead_home.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case NamedRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case NamedRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case NamedRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case NamedRoutes.sendOtp:
        return MaterialPageRoute(builder: (_) => const SendOtpScreen());
      case NamedRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case NamedRoutes.voterList:
        return MaterialPageRoute(builder: (_) => VoterListScreen());
      case NamedRoutes.yaadiLead:
        return MaterialPageRoute(builder: (_) => const YaadiLeadHome());
      case NamedRoutes.coreCommittee:
        return MaterialPageRoute(builder: (_) => const CoreCommiteeHome());
      case NamedRoutes.voterByBhag:
        return MaterialPageRoute(builder: (_) => const VoterListByBhag());
      case NamedRoutes.prabhag:
        var args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => PrabhagScreen(prabhagNo: args['prabhagNo']));
      case NamedRoutes.voterDetail:
        var args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => VoterDetailsScreen(voter: args['voterDetail']));

      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(
                    child: Text('Page Not Found'),
                  ),
                ));
    }
  }
}
