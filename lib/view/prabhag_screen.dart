import 'package:election_booth/resources/elb_appbar.dart';
import 'package:flutter/material.dart';

class PrabhagScreen extends StatefulWidget {
  static const routeName = 'prabhag_screen';
  final int prabhagNo;

  const PrabhagScreen({super.key, required this.prabhagNo});

  @override
  State<PrabhagScreen> createState() => _PrabhagScreenState();
}

class _PrabhagScreenState extends State<PrabhagScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ElbAppBar(
          leading: false,
          drawer: false,
          actions: const [],
          text: 'Prabhag ${widget.prabhagNo}',
          context: context),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
