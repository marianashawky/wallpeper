import 'package:flutter/foundation.dart';

import '../../../data/local/local_store.dart';

class FavoritesController extends ChangeNotifier {
  FavoritesController(this._store);

  final LocalStore _store;
  List<String> _order = const [];
  Set<String> _ids = const {};

  List<String> get ids => _order;

  bool isFavorite(String id) => _ids.contains(id);

  Future<void> load() async {
    _order = _store.favoriteIds;
    _ids = _order.toSet();
    notifyListeners();
  }

  Future<void> toggle(String id) async {
    await _store.toggleFavorite(id);
    _order = _store.favoriteIds;
    _ids = _order.toSet();
    notifyListeners();
  }
}
