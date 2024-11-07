import 'package:election_booth/model/user_roles.dart';
import 'package:election_booth/model/voter_data.dart';
import 'package:election_booth/repository/home_repository.dart';
import 'package:election_booth/resources/elb_appbar.dart';
import 'package:election_booth/utils/routes/named_routes.dart';
import 'package:election_booth/viewModel/AuthProvider.dart';
import 'package:election_booth/viewModel/user_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoreCommiteeHome extends StatefulWidget {
  static const String routeName = 'core_committee_screen';

  const CoreCommiteeHome({super.key});

  @override
  State<CoreCommiteeHome> createState() => _CoreCommiteeHomeState();
}

class _CoreCommiteeHomeState extends State<CoreCommiteeHome> {
  HomeRepository hr = HomeRepository();

  Future<void> _refreshData() async {
    setState(() {});
  }

  String getRoleString(Roles r) {
    switch (r) {
      case Roles.ROLE_ADMIN:
        return '(Admin)';
      case Roles.ROLE_CORE_COMMITTEE:
        return '(Core Committee member)';
      case Roles.ROLE_YAADI_LEADER:
        return '(yaadi leader)';
      default:
        return '(Core Committee member)';
    }
  }

  Future<VoterData>? fetchVoterData() async {
    var v = await hr.getVoterDataCoreCommittee(context: context);

    if (v != null) {
      return v;
    } else {
      return Future.error('Failed to fetch voter data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Consumer<UserProvider>(
          builder: (c, pr, w) {
            var u = pr.user;
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: null,
                  accountName: Text(
                    '${u.firstName} ${u.lastName} ${getRoleString(u.roles[0])}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(
                    u.username!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.indigo,
                  ),
                ),
                if (u.roles[0] != Roles.ROLE_CORE_COMMITTEE) ...[
                  ListTile(
                    leading: const Icon(Icons.group),
                    title: const Text('Voter List'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, NamedRoutes.voterList);
                    },
                  )
                ],
                Consumer<AuthProvider>(builder: (c, lg, w) {
                  return ListTile(
                    leading: lg.loading
                        ? Transform.scale(
                            scale: 0.8,
                            child: const CircularProgressIndicator())
                        : const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () {
                      lg.logout(context: c);
                    },
                  );
                })
              ],
            );
          },
        ),
      ),
      appBar: ElbAppBar(
          leading: false,
          drawer: true,
          actions: const [],
          text: 'Dashboard',
          context: context),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Voter Data By Bhag',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height / 2.2,
                  child: GridView.count(
                    crossAxisCount: 2,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 5,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, NamedRoutes.voterByBhag);
                        },
                        child: Column(
                          children: [
                            const Text(
                              'Bhag 1',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey[50],
                                    borderRadius: BorderRadius.circular(8)),
                                child: FutureBuilder<VoterData>(
                                  future: fetchVoterData(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else {
                                      final data = snapshot.data!;
                                      if (data.totalVoters == 0) {
                                        return const Center(
                                            child: Text('No Data Available'));
                                      }
                                      return PieChart(data.pieChartData());
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const Text(
                            'Bhag 2',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey[50],
                                  borderRadius: BorderRadius.circular(8)),
                              child: PieChart(PieChartData(
                                sections: [
                                  PieChartSectionData(
                                    value: 0.0,
                                    color: Colors.blueAccent,
                                    title: 'Voted: ${0.toStringAsFixed(0)}',
                                    titleStyle: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  PieChartSectionData(
                                    value: 100,
                                    color: Colors.redAccent,
                                    title:
                                        'Not Voted: ${100.toStringAsFixed(0)}',
                                    titleStyle: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                                sectionsSpace: 1,
                                centerSpaceRadius: 30,
                                startDegreeOffset: 100.0,
                                borderData: FlBorderData(show: false),
                              )),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Bhag 3',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey[50],
                                  borderRadius: BorderRadius.circular(8)),
                              child: PieChart(PieChartData(
                                sections: [
                                  PieChartSectionData(
                                    value: 0.0,
                                    color: Colors.blueAccent,
                                    title: 'Voted: ${0.toStringAsFixed(0)}',
                                    titleStyle: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  PieChartSectionData(
                                    value: 100,
                                    color: Colors.redAccent,
                                    title:
                                        'Not Voted: ${100.toStringAsFixed(0)}',
                                    titleStyle: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                                sectionsSpace: 1,
                                centerSpaceRadius: 30,
                                startDegreeOffset: 100.0,
                                borderData: FlBorderData(show: false),
                              )),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Bhag 4',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey[50],
                                  borderRadius: BorderRadius.circular(8)),
                              child: PieChart(PieChartData(
                                sections: [
                                  PieChartSectionData(
                                    value: 0.0,
                                    color: Colors.blueAccent,
                                    title: 'Voted: ${0.toStringAsFixed(0)}',
                                    titleStyle: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  PieChartSectionData(
                                    value: 100,
                                    color: Colors.redAccent,
                                    title:
                                        'Not Voted: ${100.toStringAsFixed(0)}',
                                    titleStyle: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                                sectionsSpace: 1,
                                centerSpaceRadius: 30,
                                startDegreeOffset: 100.0,
                                borderData: FlBorderData(show: false),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 2.5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
