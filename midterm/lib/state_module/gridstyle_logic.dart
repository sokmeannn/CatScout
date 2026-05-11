import 'package:flutter/material.dart';

class GridstyleLogic extends ChangeNotifier {
  bool _gridStyle = false;
  bool get gridstyle => _gridStyle;

  void toggleStyle() {
    _gridStyle = !_gridStyle;
    notifyListeners();
  }
}
