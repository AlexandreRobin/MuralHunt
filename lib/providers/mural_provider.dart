import 'package:flutter/material.dart';
import 'package:muralhunt/utils/mural.dart';

class MuralProvider with ChangeNotifier {
  Iterable<Mural> _murals = [];

  Iterable<Mural> get murals => _murals;

  void setAll(Iterable<Mural> murals) {
    _murals = murals;
    notifyListeners();
  }

  Mural getById(String id) {
    return _murals.firstWhere((element) => element.id == id);
  }

  void updateById(Mural mural) {
    _murals.map((element) => element.id == mural.id ? mural : element);
    notifyListeners();
  }

  int numberCaptured() {
    return _murals.where((element) => element.isCaptured).length;
  }

}
