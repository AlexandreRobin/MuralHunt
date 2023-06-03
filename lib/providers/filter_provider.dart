import 'package:flutter/material.dart';

class FilterProvider with ChangeNotifier {
  bool _notCaptured = true;
  bool _captured = true;

  bool get notCaptured => _notCaptured;
  bool get captured => _captured;

  void filterAll() {
    _notCaptured = true;
    _captured = true;
    notifyListeners();
  }

  void filterNotCaptured() {
    _notCaptured = true;
    _captured = false;
    notifyListeners();
  }

  void filterCaptured() {
    _notCaptured = false;
    _captured = true;
    notifyListeners();
  }
}
