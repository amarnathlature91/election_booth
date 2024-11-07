import 'package:flutter/material.dart';

class PageNotFound extends StatefulWidget {
  static const String routeName = 'page_not_found';

  const PageNotFound({super.key});

  @override
  State<PageNotFound> createState() => _PageNotFoundState();
}

class _PageNotFoundState extends State<PageNotFound> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Page Not Found'),
      ),
    );
  }
}
