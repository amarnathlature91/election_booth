import 'package:election_booth/model/voter.dart';
import 'package:election_booth/resources/elb_appbar.dart';
import 'package:flutter/material.dart';

class VoterDetailsScreen extends StatelessWidget {
  static const String routeName = 'voter_detail_screen';
  final Voter voter;

  const VoterDetailsScreen({super.key, required this.voter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ElbAppBar(
          leading: true,
          actions: const [],
          text: 'Voter Details',
          context: context,
          drawer: false),
      body: Card(
        color: Colors.blueGrey[50],
        elevation: 5,
        margin: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name and Name in Marathi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      voter.fullName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                  ),
                  Icon(Icons.person, color: Colors.blueGrey[700]),
                ],
              ),
              const SizedBox(height: 4.0),
              Text(
                'Name in Marathi: ${voter.fullNameInMarathi}',
                style: TextStyle(fontSize: 16, color: Colors.blueGrey[600]),
              ),
              Divider(color: Colors.blueGrey[200], thickness: 1),
              _buildInfoRow(
                icon: Icons.how_to_vote_outlined,
                label: 'Voter ID',
                value: voter.voterId,
              ),
              _buildInfoRow(
                icon: Icons.phone_outlined,
                label: 'Mobile',
                value: voter.mobNo,
              ),
              _buildInfoRow(
                icon: Icons.cake_outlined,
                label: 'Date of Birth',
                value: voter.mobNo,
              ),
              Divider(color: Colors.blueGrey[200], thickness: 1),

              _buildInfoRow(
                icon: Icons.location_on_outlined,
                label: 'Address',
                value: voter.address,
              ),
              _buildInfoRow(
                icon: Icons.how_to_vote_outlined,
                label: 'Voting Center',
                value: voter.votingCenter,
              ),
              _buildInfoRow(
                icon: Icons.featured_play_list_outlined,
                label: 'Yaadi Lead Name',
                value: voter.yaadiLeadName,
              ),
              _buildInfoRow(
                icon: Icons.call_outlined,
                label: 'Yaadi Lead Mobile',
                value: voter.yaadiLeadMobNo,
              ),
              Divider(color: Colors.blueGrey[200], thickness: 1),

              // Voted Status
              _buildStatusRow(
                label: 'Voted',
                status: voter.voted,
                trueIcon: Icons.check_circle,
                falseIcon: Icons.cancel,
              ),
              // Name in List Status
              _buildStatusRow(
                label: 'Name in Yaadi',
                status: voter.nameInYaadi,
                trueIcon: Icons.check_circle,
                falseIcon: Icons.cancel,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey[700]),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: '$label : ',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: value.isEmpty ? 'Not Available' : value)
                ],
                style: TextStyle(fontSize: 16, color: Colors.blueGrey[800]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow({
    required String label,
    required bool status,
    required IconData trueIcon,
    required IconData falseIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800]),
          ),
          Icon(
            status ? trueIcon : falseIcon,
            color: status ? Colors.green : Colors.red,
          ),
          SizedBox(width: 10),
          Text(
            status ? 'Yes' : 'No',
            style: TextStyle(
                fontSize: 16,
                color: status ? Colors.green[700] : Colors.red[700]),
          ),
        ],
      ),
    );
  }
}

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: ElbAppBar(
//         leading: true,
//         actions: const [],
//         text: 'Voter Details',
//         context: context,
//         drawer: false),
//     body: Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           detailRow(voter.fullName,
//               prop: 'Full Name', icon: Icons.person_outline),
//           detailRow(voter.fullNameInMarathi,
//               prop: 'Full Name In Marathi', icon: Icons.language),
//           detailRow(voter.dob,
//               prop: 'Date of Birth', icon: Icons.date_range_outlined),
//           detailRow(voter.voterId,
//               prop: 'Voter ID', icon: Icons.how_to_vote_outlined),
//           detailRow(voter.mobNo, prop: 'Mobile', icon: Icons.call_outlined),
//           detailRow(voter.address,
//               prop: 'Address', icon: Icons.location_on_outlined),
//           detailRow(voter.votingCenter,
//               prop: 'Voting Center', icon: Icons.location_city_outlined),
//           detailRow(voter.yaadiLeadName,
//               prop: 'Yaadi Lead Name',
//               icon: Icons.featured_play_list_outlined),
//           detailRow(voter.yaadiLeadMobNo,
//               prop: 'Yaadi Lead Mobile', icon: Icons.call_outlined),
//           voter.voted
//               ? const Row(
//                   children: [
//                     Icon(
//                       Icons.radio_button_checked,
//                       color: Colors.blueAccent,
//                     ),
//                     Text(
//                       'Voted',
//                       style: TextStyle(
//                           color: Colors.blueAccent,
//                           fontWeight: FontWeight.bold),
//                     )
//                   ],
//                 )
//               : const Row(
//                   children: [
//                     Icon(Icons.radio_button_off, color: Colors.redAccent),
//                     Text(
//                       'Not Voted',
//                       style: TextStyle(
//                           color: Colors.redAccent,
//                           fontWeight: FontWeight.bold),
//                     )
//                   ],
//                 ),
//           voter.nameInYaadi
//               ? const Row(
//                   children: [
//                     Icon(
//                       Icons.radio_button_checked,
//                       color: Colors.blueAccent,
//                     ),
//                     Text(
//                       'Name Available In Yaadi',
//                       style: TextStyle(
//                           color: Colors.blueAccent,
//                           fontWeight: FontWeight.bold),
//                     )
//                   ],
//                 )
//               : const Row(
//                   children: [
//                     Icon(Icons.radio_button_off, color: Colors.redAccent),
//                     Text(
//                       'Name Not Available In Yaadi',
//                       style: TextStyle(
//                           color: Colors.redAccent,
//                           fontWeight: FontWeight.bold),
//                     )
//                   ],
//                 ),
//         ],
//       ),
//     ),
//   );
// }
//
// Widget detailRow(dynamic val,
//     {required String prop, required IconData icon}) {
//   return val != null
//       ? Row(
//           children: [
//             Icon(
//               icon,
//               color: Colors.black54,
//               size: 30,
//             ),
//             const SizedBox(
//               width: 5,
//             ),
//             Expanded(
//               child: Text.rich(
//                 TextSpan(children: [
//                   TextSpan(
//                       text: '$prop : ',
//                       style: const TextStyle(color: Colors.black87)),
//                   if (val is DateTime)
//                     TextSpan(
//                         text: '${val.day}-${val.month}-${val.year}',
//                         style: const TextStyle(color: Colors.black54)),
//                   if (val is String)
//                     TextSpan(
//                         text: val,
//                         style: const TextStyle(color: Colors.black54))
//                 ]),
//                 style: const TextStyle(fontSize: 16),
//               ),
//             ),
//           ],
//         )
//       : const SizedBox.shrink();
// }
