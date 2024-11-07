import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class VoterData {
  final double totalVoters;
  final double remainingVoters;
  final double doneVoters;
  final double totalPercentage;

  VoterData({
    required this.totalVoters,
    required this.remainingVoters,
    required this.doneVoters,
    required this.totalPercentage,
  });

  static double roundToTwoDecimal(double value) {
    return (value * 100).round() / 100;
  }

  factory VoterData.fromJson(Map<String, dynamic> json) {
    return VoterData(
      totalVoters: json['totalVoters']?.toDouble() ?? 0.0,
      remainingVoters: json['remainingVoters']?.toDouble() ?? 0.0,
      doneVoters: json['doneVoters']?.toDouble() ?? 0.0,
      totalPercentage: VoterData.roundToTwoDecimal(
          json['totalPercentage']?.toDouble() ?? 0.0),
    );
  }

  pieChartData() {
    double voted = totalVoters - remainingVoters;
    double votedPercentage = (voted / totalVoters) * 100;
    double remainingPercentage = (remainingVoters / totalVoters) * 100;
    return PieChartData(
      sections: [
        PieChartSectionData(
          value: votedPercentage,
          color: Colors.blueAccent,
          title: 'Voted: ${doneVoters.toStringAsFixed(0)}',
          titleStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        PieChartSectionData(
          value: remainingPercentage,
          color: Colors.redAccent,
          title: 'Not Voted: ${remainingVoters.toStringAsFixed(0)}',
          titleStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
      sectionsSpace: 1,
      centerSpaceRadius: 30,
      startDegreeOffset: 100.0,
      borderData: FlBorderData(show: false),
    );
  }
}

// class VoterData {
//   final double? totalVoters;
//   final double? remainingVoters;
//   final double? totalPercentage;
//   final double? totalPrabhagOneVoters;
//   final double? remainingPrabhagOneVoters;
//   final double? prabhagOnePercentage;
//   final double? totalPrabhagTwoVoters;
//   final double? remainingPrabhagTwoVoters;
//   final double? prabhagTwoPercentage;
//   final double? totalPrabhagThreeVoters;
//   final double? remainingPrabhagThreeVoters;
//   final double? prabhagThreePercentage;
//   final double? totalPrabhagFourVoters;
//   final double? remainingPrabhagFourVoters;
//   final double? prabhagFourPercentage;
//   final double? totalPrabhagFiveVoters;
//   final double? remainingPrabhagFiveVoters;
//   final double? prabhagFivePercentage;
//   final double? totalPrabhagSixVoters;
//   final double? remainingPrabhagSixVoters;
//   final double? prabhagSixPercentage;
//   final double? totalPrabhagSevenVoters;
//   final double? remainingPrabhagSevenVoters;
//   final double? prabhagSevenPercentage;
//   final double? totalPrabhagEightVoters;
//   final double? remainingPrabhagEightVoters;
//   final double? prabhagEightPercentage;
//
//   VoterData({
//     this.totalVoters,
//     this.remainingVoters,
//     this.totalPercentage,
//     this.totalPrabhagOneVoters,
//     this.remainingPrabhagOneVoters,
//     this.prabhagOnePercentage,
//     this.totalPrabhagTwoVoters,
//     this.remainingPrabhagTwoVoters,
//     this.prabhagTwoPercentage,
//     this.totalPrabhagThreeVoters,
//     this.remainingPrabhagThreeVoters,
//     this.prabhagThreePercentage,
//     this.totalPrabhagFourVoters,
//     this.remainingPrabhagFourVoters,
//     this.prabhagFourPercentage,
//     this.totalPrabhagFiveVoters,
//     this.remainingPrabhagFiveVoters,
//     this.prabhagFivePercentage,
//     this.totalPrabhagSixVoters,
//     this.remainingPrabhagSixVoters,
//     this.prabhagSixPercentage,
//     this.totalPrabhagSevenVoters,
//     this.remainingPrabhagSevenVoters,
//     this.prabhagSevenPercentage,
//     this.totalPrabhagEightVoters,
//     this.remainingPrabhagEightVoters,
//     this.prabhagEightPercentage,
//   });
//
//   factory VoterData.fromJson(Map<String, dynamic> json) {
//     return VoterData(
//       totalVoters: json['totalVoters']?.toDouble() ?? 0.0,
//       remainingVoters: json['remainingVoters']?.toDouble() ?? 0.0,
//       totalPercentage: json['totalPercentage']?.toDouble() ?? 0.0,
//       totalPrabhagOneVoters: json['totalPrabhagOneVoters']?.toDouble() ?? 0.0,
//       remainingPrabhagOneVoters:
//           json['remainingPrabhagOneVoters']?.toDouble() ?? 0.0,
//       prabhagOnePercentage: json['prabhagOnePercentage']?.toDouble() ?? 0.0,
//       totalPrabhagTwoVoters: json['totalPrabhagTwoVoters']?.toDouble() ?? 0.0,
//       remainingPrabhagTwoVoters:
//           json['remainingPrabhagTwoVoters']?.toDouble() ?? 0.0,
//       prabhagTwoPercentage: json['prabhagTwoPercentage']?.toDouble() ?? 0.0,
//       totalPrabhagThreeVoters:
//           json['totalPrabhagThreeVoters']?.toDouble() ?? 0.0,
//       remainingPrabhagThreeVoters:
//           json['remainingPrabhagThreeVoters']?.toDouble() ?? 0.0,
//       prabhagThreePercentage: json['prabhagThreePercentage']?.toDouble() ?? 0.0,
//       totalPrabhagFourVoters: json['totalPrabhagFourVoters']?.toDouble() ?? 0.0,
//       remainingPrabhagFourVoters:
//           json['remainingPrabhagFourVoters']?.toDouble() ?? 0.0,
//       prabhagFourPercentage: json['prabhagFourPercentage']?.toDouble() ?? 0.0,
//       totalPrabhagFiveVoters: json['totalPrabhagFiveVoters']?.toDouble() ?? 0.0,
//       remainingPrabhagFiveVoters:
//           json['remainingPrabhagFiveVoters']?.toDouble() ?? 0.0,
//       prabhagFivePercentage: json['prabhagFivePercentage']?.toDouble() ?? 0.0,
//       totalPrabhagSixVoters: json['totalPrabhagSixVoters']?.toDouble() ?? 0.0,
//       remainingPrabhagSixVoters:
//           json['remainingPrabhagSixVoters']?.toDouble() ?? 0.0,
//       prabhagSixPercentage: json['prabhagSixPercentage']?.toDouble() ?? 0.0,
//       totalPrabhagSevenVoters:
//           json['totalPrabhagSevenVoters']?.toDouble() ?? 0.0,
//       remainingPrabhagSevenVoters:
//           json['remainingPrabhagSevenVoters']?.toDouble() ?? 0.0,
//       prabhagSevenPercentage: json['prabhagSevenPercentage']?.toDouble() ?? 0.0,
//       totalPrabhagEightVoters:
//           json['totalPrabhagEightVoters']?.toDouble() ?? 0.0,
//       remainingPrabhagEightVoters:
//           json['remainingPrabhagEightVoters']?.toDouble() ?? 0.0,
//       prabhagEightPercentage: json['prabhagEightPercentage']?.toDouble() ?? 0.0,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'totalVoters': totalVoters,
//       'remainingVoters': remainingVoters,
//       'totalPercentage': totalPercentage,
//       'totalPrabhagOneVoters': totalPrabhagOneVoters,
//       'remainingPrabhagOneVoters': remainingPrabhagOneVoters,
//       'prabhagOnePercentage': prabhagOnePercentage,
//       'totalPrabhagTwoVoters': totalPrabhagTwoVoters,
//       'remainingPrabhagTwoVoters': remainingPrabhagTwoVoters,
//       'prabhagTwoPercentage': prabhagTwoPercentage,
//       'totalPrabhagThreeVoters': totalPrabhagThreeVoters,
//       'remainingPrabhagThreeVoters': remainingPrabhagThreeVoters,
//       'prabhagThreePercentage': prabhagThreePercentage,
//       'totalPrabhagFourVoters': totalPrabhagFourVoters,
//       'remainingPrabhagFourVoters': remainingPrabhagFourVoters,
//       'prabhagFourPercentage': prabhagFourPercentage,
//       'totalPrabhagFiveVoters': totalPrabhagFiveVoters,
//       'remainingPrabhagFiveVoters': remainingPrabhagFiveVoters,
//       'prabhagFivePercentage': prabhagFivePercentage,
//       'totalPrabhagSixVoters': totalPrabhagSixVoters,
//       'remainingPrabhagSixVoters': remainingPrabhagSixVoters,
//       'prabhagSixPercentage': prabhagSixPercentage,
//       'totalPrabhagSevenVoters': totalPrabhagSevenVoters,
//       'remainingPrabhagSevenVoters': remainingPrabhagSevenVoters,
//       'prabhagSevenPercentage': prabhagSevenPercentage,
//       'totalPrabhagEightVoters': totalPrabhagEightVoters,
//       'remainingPrabhagEightVoters': remainingPrabhagEightVoters,
//       'prabhagEightPercentage': prabhagEightPercentage,
//     };
//   }
// }
