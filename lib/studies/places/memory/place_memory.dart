import 'package:flutter/widgets.dart';

/// What the list remembers for this run of the app. Nothing is written to disk.
class PlaceMemory extends ChangeNotifier {
  PlaceMemory._();

  static final instance = PlaceMemory._();

  final _saved = <int>{};
  final _photo = <int, int>{};
  final _openedSaved = <int, bool>{};
  int? cueId;

  bool isSaved(int id) => _saved.contains(id);

  int photoOf(int id) => _photo[id] ?? 0;

  void toggleSaved(int id) {
    if (!_saved.remove(id)) _saved.add(id);
    notifyListeners();
  }

  void setPhoto(int id, int index) {
    if (_photo[id] == index) return;
    _photo[id] = index;
    notifyListeners();
  }

  void beginVisit(int id) => _openedSaved[id] = isSaved(id);

  /// After the card has landed, ask it to settle a mark that changed.
  void finishVisit(int id) {
    final before = _openedSaved[id];
    cueId = before != null && before != isSaved(id) ? id : null;
    if (cueId != null) notifyListeners();
  }

  void reset() {
    _saved.clear();
    _photo.clear();
    _openedSaved.clear();
    cueId = null;
    notifyListeners();
  }

  void clearCue() {
    if (cueId == null) return;
    cueId = null;
    notifyListeners();
  }
}
