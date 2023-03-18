import 'dart:convert';
import 'dart:io';

import 'package:chat_gpt/constants/api_const.dart';
import 'package:chat_gpt/models/chat.dart';
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

  static Future<List<ChatModel>> sendMessage({
    required String message,
    required String modelId,
  }) async {
    try {
      var response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "model": modelId,
            "messages": [
              {"role": "user", "content": message}
            ],
            "temperature": 0.7
          },
        ),
      );
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse["error"] != null) {
        throw HttpException(jsonResponse["error"]["message"]);
      }

      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        chatList = List.generate(
            jsonResponse["choices"].length,
            (index) => ChatModel(
                msg: jsonResponse["choices"][index]["message"]["content"], chatIndex: 1));
      }
      return chatList;
    } catch (err) {
      rethrow;
    }
  }
}
