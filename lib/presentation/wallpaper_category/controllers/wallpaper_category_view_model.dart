import 'package:flutter/foundation.dart';

class WallpaperCategoryViewModel extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}
