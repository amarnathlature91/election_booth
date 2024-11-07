import 'dart:async';

import 'package:election_booth/model/user_roles.dart';
import 'package:election_booth/model/voter.dart';
import 'package:election_booth/repository/voter_list_repository.dart';
import 'package:election_booth/resources/ElbtextField.dart';
import 'package:election_booth/resources/elb_appbar.dart';
import 'package:election_booth/resources/elb_button.dart';
import 'package:election_booth/utils/routes/named_routes.dart';
import 'package:election_booth/utils/utils.dart';
import 'package:election_booth/viewModel/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VoterListByBhag extends StatefulWidget {
  static const routeName = 'voter_list_by_bhag';

  const VoterListByBhag({super.key});

  @override
  _VoterListByBhagState createState() => _VoterListByBhagState();
}

class _VoterListByBhagState extends State<VoterListByBhag> {
  VoterListRepository vr = VoterListRepository();

  List<Voter> _voters = [];
  int? _expandedIndex;
  bool _isFetchingVoters = false;
  bool _isFetchingMoreVoters = false;
  bool _isFetchingError = false;
  bool _isUpdatingVoted = false;
  int _currentPage = 0;

  String _searchQuery = '';
  String _selectedFilter = '';
  Timer? _searchDebounce;

  List<Voter> voters = [];
  TextEditingController _serachController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchVoters();
  }

  void onSearchChanged({required String query}) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 1200), () {
      _searchQuery = query;
      fetchVoters();
    });
  }

  void setFilter({required String filter}) {
    _selectedFilter = filter;
    fetchVoters();
  }

  void updateIsVoted({required BuildContext context, required int index}) {
    _voters[index].voted = !_voters[index].voted;
    vr.updateVoted(context: context, id: _voters[index].id);
  }

  void loadMoreVoters() async {
    _currentPage++;
    try {
      setState(() {
        _isFetchingError = false;
        _isFetchingMoreVoters = true;
      });

      var v = await vr.getVoterList(
          context: context,
          pageNo: _currentPage,
          searchText: _searchQuery,
          votedOrNot: _selectedFilter);
      _voters.addAll(v);
      if (v.isEmpty) {
        Utils.showGeneral(context, 'End of List');
      }
    } catch (e) {
      setState(() {
        _isFetchingError = true;
      });
    } finally {
      setState(() {
        _isFetchingMoreVoters = false;
      });
    }
  }

  void refresh() async {
    _currentPage = 0;
    setFilter(filter: '');
    fetchVoters();
  }

  Future<void> fetchVoters() async {
    try {
      setState(() {
        _isFetchingError = false;
        _isFetchingVoters = true;
      });
      _voters = await vr.getVoterList(
          context: context,
          pageNo: _currentPage,
          searchText: _searchQuery,
          votedOrNot: _selectedFilter);
      print(_voters.length);
    } catch (e) {
      setState(() {
        _isFetchingError = true;
      });
    } finally {
      setState(() {
        _isFetchingVoters = false;
      });
    }
  }

  void toggleExpand(int index) async {
    await Future.delayed(const Duration(milliseconds: 150), () {
      _expandedIndex = _expandedIndex == index ? null : index;
    });
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
        body: Column(
          children: [
            // Search Field
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElbTextField(
                  controller: _serachController,
                  hintText: 'Search by name or voter ID',
                  labelText: 'Search',
                  onChanged: (v) {
                    onSearchChanged(query: v);
                  },
                )),
            //filter chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: _selectedFilter == '',
                    onSelected: (bool selected) {
                      setFilter(filter: '');
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Voted'),
                    selected: _selectedFilter == 'Voted',
                    onSelected: (bool selected) {
                      setFilter(filter: 'Voted');
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Non-Voted'),
                    selected: _selectedFilter == 'NotVoted',
                    onSelected: (bool selected) {
                      setFilter(filter: 'NotVoted');
                    },
                  ),
                ],
              ),
            ),
            // List of Voters
            _isFetchingVoters
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        refresh();
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: voters.length + 1,
                        physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        itemBuilder: (context, index) {
                          if (index < voters.length) {
                            return Container(
                              padding: const EdgeInsets.all(16.0),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 8.0),
                              decoration: BoxDecoration(
                                color: _expandedIndex == index
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
                                          Navigator.pushNamed(
                                              context, NamedRoutes.voterDetail,
                                              arguments: {
                                                'voterDetail': voters[index]
                                              });
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              voters[index].fullName,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                'Voter ID: ${voters[index].voterId}'),
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
                                          if (r[0] == Roles.ROLE_YAADI_LEADER) {
                                            toggleExpand(index);
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                            color: voters[index].voted
                                                ? Colors.green
                                                : Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Text(
                                            voters[index].voted
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
                                  if (_expandedIndex == index) ...[
                                    Container(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () {
                                                updateIsVoted(
                                                    context: context,
                                                    index: index);
                                                toggleExpand(index);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                minimumSize: const Size(60, 40),
                                                textStyle: const TextStyle(
                                                  fontSize: 15,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                              ),
                                              child: const Text('Voted',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ))),
                                          ElevatedButton(
                                            onPressed: () {
                                              updateIsVoted(
                                                  context: context,
                                                  index: index);
                                              toggleExpand(index);
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
                            return voters.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: ElbButton(
                                        text: 'Load More',
                                        isLoading: _isFetchingMoreVoters,
                                        onPressed: () {
                                          loadMoreVoters();
                                        }),
                                  )
                                : Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height /
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
        ));
  }
}
