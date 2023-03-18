import 'dart:convert';
import 'dart:io';

import 'package:chat_gpt/constants/api_const.dart';
import 'package:chat_gpt/models/models.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<Models>> getModels() async {
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/models"),
        headers: {
          "Authorization": "Bearer $apiKey",
        },
      );
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse["error"] != null) {
        throw HttpException(jsonResponse["error"]["message"]);
      }

      List temp = [];
      for (var data in jsonResponse["data"]) {
        temp.add(data);
      }

      return Models.modelsFromSnapshot(temp);
    } catch (err) {
      rethrow;
    }
  }
}
