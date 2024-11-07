import 'package:election_booth/resources/fade_transition_builder.dart';
import 'package:election_booth/utils/routes/app_routes.dart';
import 'package:election_booth/utils/routes/named_routes.dart';
import 'package:election_booth/viewModel/AuthProvider.dart';
import 'package:election_booth/viewModel/user_provider.dart';
import 'package:election_booth/viewModel/voter_data_provider.dart';
import 'package:election_booth/viewModel/voter_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => VoterListProvider()),
        ChangeNotifierProvider(create: (_) => VoterDataProvider()),
      ],
      child: MaterialApp(
          title: 'Election Booth',
          debugShowCheckedModeBanner: false,
          initialRoute: NamedRoutes.splash,
          theme: ThemeData(
              pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: FadeTransitionBuilder(),
              TargetPlatform.iOS: FadeTransitionBuilder(),
            },
          )),
          onGenerateRoute: AppRoutes.generateRoutes),
    );
  }
}
