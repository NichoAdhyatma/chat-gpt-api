import 'package:chat_gpt/models/models.dart';
import 'package:chat_gpt/services/api_service.dart';
import 'package:flutter/material.dart';

class ModelsProvider with ChangeNotifier {
  List<Models> _models = [];
  String _currentModels = "gpt-3.5-turbo";

  List<Models> get getModels => _models;
  String get getCurrentModels => _currentModels;

  void setCurrentModels(String newModel) {
    _currentModels = newModel;
    notifyListeners();
  }

  Future<List<Models>> getAllModels() async {
    _models = await ApiService.getModels();
    return _models;
  }

}
