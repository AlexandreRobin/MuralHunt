import 'package:flutter/material.dart';
import 'package:muralhunt/utils/mural.dart';

class MuralProvider with ChangeNotifier {
  List<Mural> _murals = [];

  List<Mural> get murals => _murals;

  void setAll(List<Mural> murals) {
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

  List<Mural> getGallery() {
    List<Mural> murals =
        _murals.where((element) => element.isCaptured).toList();
    murals.sort((a, b) => b.capturedDate.compareTo(a.capturedDate));
    return murals;
  }
}
