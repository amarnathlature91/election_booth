import 'package:election_booth/model/user_roles.dart';
import 'package:election_booth/resources/elb_appbar.dart';
import 'package:election_booth/resources/elb_button.dart';
import 'package:election_booth/utils/routes/named_routes.dart';
import 'package:election_booth/viewModel/voter_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../resources/ElbtextField.dart';
import '../viewModel/user_provider.dart';

class VoterListScreen extends StatefulWidget {
  static const routeName = 'voter_list_screen';

  @override
  _VoterListScreenState createState() => _VoterListScreenState();
}

class _VoterListScreenState extends State<VoterListScreen> {
  TextEditingController _serachController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var pr = Provider.of<VoterListProvider>(context, listen: false);
      pr.fetchVoters(context: context);
      pr.setCurrentPage(0);
    });

    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     Provider.of<VoterListProvider>(context, listen: false)
    //         .loadMoreVoters(context: context);
    //     _scrollController.position.maxScrollExtent;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ElbAppBar(
          leading: true,
          drawer: false,
          actions: const [],
          text: 'Voter List',
          context: context),
      body: Consumer<VoterListProvider>(
        builder: (c, pr, w) {
          return Column(
            children: [
              // Search Field
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElbTextField(
                    controller: _serachController,
                    hintText: 'Search by name or voter ID',
                    labelText: 'Search',
                    onChanged: (v) {
                      pr.onSearchChanged(context: context, query: v);
                    },
                  )),
              //filter chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: pr.selectedFilter == '',
                      onSelected: (bool selected) {
                        pr.setFilter(filter: '', context: context);
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Voted'),
                      selected: pr.selectedFilter == 'Voted',
                      onSelected: (bool selected) {
                        pr.setFilter(filter: 'Voted', context: context);
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Non-Voted'),
                      selected: pr.selectedFilter == 'NotVoted',
                      onSelected: (bool selected) {
                        pr.setFilter(filter: 'NotVoted', context: context);
                      },
                    ),
                  ],
                ),
              ),
              // List of Voters
              pr.isFetchingVoters
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          pr.refresh(context: context);
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: pr.voters.length + 1,
                          physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          itemBuilder: (context, index) {
                            if (index < pr.voters.length) {
                              return Container(
                                padding: const EdgeInsets.all(16.0),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 8.0),
                                decoration: BoxDecoration(
                                  color: pr.expandedIndex == index
                                      ? Colors.grey[200]
                                      : Colors.white,
                                  border: Border.all(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                NamedRoutes.voterDetail,
                                                arguments: {
                                                  'voterDetail':
                                                      pr.voters[index]
                                                });
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                pr.voters[index].fullName,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  'Voter ID: ${pr.voters[index].voterId}'),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            var r = Provider.of<UserProvider>(
                                                    context,
                                                    listen: false)
                                                .user
                                                .roles;
                                            if (r[0] ==
                                                Roles.ROLE_YAADI_LEADER) {
                                              pr.toggleExpand(index);
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(7),
                                            decoration: BoxDecoration(
                                              color: pr.voters[index].voted
                                                  ? Colors.green
                                                  : Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Text(
                                              pr.voters[index].voted
                                                  ? 'Voted'
                                                  : 'Not-Voted',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (pr.expandedIndex == index) ...[
                                      Container(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  pr.updateIsVoted(
                                                      context: context,
                                                      index: index);
                                                  pr.toggleExpand(index);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  minimumSize:
                                                      const Size(60, 40),
                                                  textStyle: const TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                ),
                                                child: const Text('Voted',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ))),
                                            ElevatedButton(
                                              onPressed: () {
                                                pr.updateIsVoted(
                                                    context: context,
                                                    index: index);
                                                pr.toggleExpand(index);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                minimumSize: const Size(60, 40),
                                                textStyle: const TextStyle(
                                                  fontSize: 15,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                              ),
                                              child: const Text(
                                                'Not-Voted',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ]
                                  ],
                                ),
                              );
                            } else {
                              return pr.voters.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: ElbButton(
                                          text: 'Load More',
                                          isLoading: pr.isFetchingMoreVoters,
                                          onPressed: () {
                                            pr.loadMoreVoters(context: context);
                                          }),
                                    )
                                  : Column(
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.sizeOf(context)
                                                  .height /
                                              5,
                                        ),
                                        const Center(
                                          child: Text(
                                            'No Data Found',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    );
                            }
                          },
                        ),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
