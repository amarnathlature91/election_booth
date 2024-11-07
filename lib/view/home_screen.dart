import 'package:election_booth/model/user_roles.dart';
import 'package:election_booth/resources/elb_appbar.dart';
import 'package:election_booth/utils/routes/named_routes.dart';
import 'package:election_booth/viewModel/AuthProvider.dart';
import 'package:election_booth/viewModel/user_provider.dart';
import 'package:election_booth/viewModel/voter_data_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home_screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VoterDataProvider>(context, listen: false)
          .loadVoterData(context: context);
    });
    super.initState();
  }

  Future<void> _refreshData() async {
    Provider.of<VoterDataProvider>(context, listen: false)
        .loadVoterData(context: context);
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
                ListTile(
                  leading: const Icon(Icons.group),
                  title: const Text('Voter List'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, NamedRoutes.voterList);
                  },
                ),
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
      body: Consumer<VoterDataProvider>(builder: (cn, pr, ch) {
        double voted = pr.voterData.totalVoters - pr.voterData.remainingVoters;
        double votedPercentage = (voted / pr.voterData.totalVoters) * 100;
        double remainingPercentage =
            (pr.voterData.remainingVoters / pr.voterData.totalVoters) * 100;

        return RefreshIndicator(
          onRefresh: _refreshData,
          child: pr.loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'Total Voter Data',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: MediaQuery.sizeOf(context).height / 3,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: voted != 0
                              ? PieChart(
                                  PieChartData(
                                    sections: [
                                      PieChartSectionData(
                                        value: voted,
                                        color: Colors.blueAccent,
                                        title:
                                            'Voted: ${votedPercentage.toStringAsFixed(1)}%',
                                        titleStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 3,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              offset: const Offset(1, 1),
                                            ),
                                          ],
                                        ),
                                        radius: 60,
                                        badgeWidget: _buildBadge(
                                            Icons.how_to_vote,
                                            Colors.blueAccent),
                                        // Adding badge
                                        badgePositionPercentageOffset: 1.2,
                                      ),
                                      PieChartSectionData(
                                        value: pr.voterData.remainingVoters,
                                        color: Colors.redAccent,
                                        title:
                                            'Not Voted: ${remainingPercentage.toStringAsFixed(1)}%',
                                        titleStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 3,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              offset: const Offset(1, 1),
                                            ),
                                          ],
                                        ),
                                        radius: 60,
                                        badgeWidget: _buildBadge(
                                            Icons.cancel, Colors.redAccent),
                                        badgePositionPercentageOffset: 1.2,
                                      ),
                                    ],
                                    sectionsSpace: 3,
                                    centerSpaceRadius: 50,
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                  ),
                                )
                              : const Center(
                                  child: Text(
                                  'No Data Available',
                                  style: TextStyle(fontSize: 20),
                                )),
                        ),
                        const SizedBox(height: 10),
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16.0),
                          children: [
                            _buildInfoCard(
                              icon: Icons.person_add_rounded,
                              iconColor: Colors.blueAccent,
                              label: 'Voted',
                              value: '${pr.voterData.doneVoters}',
                              backgroundColor: Colors.blue[50]!,
                            ),
                            _buildInfoCard(
                              icon: Icons.person_remove_rounded,
                              iconColor: Colors.redAccent,
                              label: 'Non Voted',
                              value: '${pr.voterData.remainingVoters}',
                              backgroundColor: Colors.red[50]!,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[300]!,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.people_rounded,
                                  color: Colors.black87, size: 30),
                              const SizedBox(height: 10),
                              const Text(
                                'Total Voters',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${pr.voterData.totalVoters}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     _buildInfoRow(
                        //       icon: Icons.person_add_rounded,
                        //       iconColor: Colors.blueAccent,
                        //       label: 'Voted:',
                        //       labelColor: Colors.blueAccent,
                        //       value: '${pr.voterData.doneVoters}',
                        //     ),
                        //     const SizedBox(height: 8),
                        //     _buildInfoRow(
                        //       icon: Icons.person_remove_rounded,
                        //       iconColor: Colors.redAccent,
                        //       label: 'Non Voted:',
                        //       labelColor: Colors.redAccent,
                        //       value: '${pr.voterData.remainingVoters}',
                        //     ),
                        //     const SizedBox(height: 8),
                        //     _buildInfoRow(
                        //       icon: Icons.people_rounded,
                        //       iconColor: Colors.black54,
                        //       label: 'Total Voters:',
                        //       labelColor: Colors.black54,
                        //       value: '${pr.voterData.totalVoters}',
                        //     ),
                        //   ],
                        // ),
                        const SizedBox(height: 10),

                        SizedBox(height: MediaQuery.sizeOf(context).height / 6),
                      ],
                    ),
                  ),
                ),
        );
      }),
    );
  }

  Widget _buildBadge(IconData icon, Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 4,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: 16,
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 30),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}

class PrabhagData {
  final double? total;
  final double? remaining;
  final double? percentage;

  PrabhagData(this.total, this.remaining, this.percentage);
}
