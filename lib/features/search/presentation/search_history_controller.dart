import 'package:flutter/foundation.dart';

import '../../../data/local/local_store.dart';

class SearchHistoryController extends ChangeNotifier {
  SearchHistoryController(this._store);

  final LocalStore _store;
  List<String> recent = const [];

  Future<void> load() async {
    recent = _store.recentSearches;
    notifyListeners();
  }

  Future<void> remember(String query) async {
    await _store.addRecentSearch(query);
    recent = _store.recentSearches;
    notifyListeners();
  }

  Future<void> clear() async {
    await _store.clearRecentSearches();
    recent = const [];
    notifyListeners();
  }
}
