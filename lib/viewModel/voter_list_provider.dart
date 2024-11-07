import 'dart:async';

import 'package:election_booth/model/voter.dart';
import 'package:election_booth/repository/voter_list_repository.dart';
import 'package:election_booth/utils/utils.dart';
import 'package:flutter/cupertino.dart';

class VoterListProvider with ChangeNotifier {
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

  int get currentPage => _currentPage;

  int? get expandedIndex => _expandedIndex;

  String get selectedFilter => _selectedFilter;

  VoterListRepository vr = VoterListRepository();

  bool get isFetchingVoters => _isFetchingVoters;

  bool get isFetchingMoreVoters => _isFetchingMoreVoters;

  bool get isUpdatingVoted => _isUpdatingVoted;

  bool get isFetchingError => _isFetchingError;

  List<Voter> get voters => _voters;

  void setFetching(bool v) {
    _isFetchingVoters = v;
    notifyListeners();
  }

  void setUpdating(bool v) {
    _isUpdatingVoted = v;
    notifyListeners();
  }

  void setCurrentPage(int p) {
    _currentPage = p;
    notifyListeners();
  }

  void setFetchingError(bool v) {
    _isFetchingError = v;
    notifyListeners();
  }

  void setFetchingMore(bool v) {
    _isFetchingMoreVoters = v;
    notifyListeners();
  }

  void toggleExpand(int index) async {
    await Future.delayed(const Duration(milliseconds: 150), () {
      _expandedIndex = _expandedIndex == index ? null : index;
      notifyListeners();
    });
  }

  void onSearchChanged({required String query, required BuildContext context}) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 1200), () {
      _searchQuery = query;
      fetchVoters(context: context);
    });
  }

  void setFilter({required String filter, required BuildContext context}) {
    _selectedFilter = filter;
    fetchVoters(
      context: context,
    );
  }

  void updateIsVoted({required BuildContext context, required int index}) {
    _voters[index].voted = !_voters[index].voted;
    notifyListeners();
    vr.updateVoted(context: context, id: _voters[index].id);
  }

  void loadMoreVoters({required BuildContext context}) async {
    _currentPage++;
    try {
      setFetchingError(false);
      setFetchingMore(true);
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
      setFetchingError(true);
    } finally {
      setFetchingMore(false);
    }
  }

  void refresh({required BuildContext context}) async {
    setCurrentPage(0);
    setFilter(filter: '', context: context);
    fetchVoters(context: context);
  }

  Future<void> fetchVoters({required BuildContext context}) async {
    try {
      setFetchingError(false);
      setFetching(true);
      _voters = await vr.getVoterList(
          context: context,
          pageNo: _currentPage,
          searchText: _searchQuery,
          votedOrNot: _selectedFilter);
      print(_voters.length);
    } catch (e) {
      setFetchingError(true);
    } finally {
      setFetching(false);
    }
  }
}
