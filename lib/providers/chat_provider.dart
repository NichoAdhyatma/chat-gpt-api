import 'package:chat_gpt/models/chat.dart';
import 'package:chat_gpt/services/api_service.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];
  List<ChatModel> get getChatList => chatList;

  void addUserChat(String msg) {
    chatList.add(
      ChatModel(msg: msg, chatIndex: 0),
    );
    notifyListeners();
  }

  Future<void> addAiChat(String msg, String model) async {
    chatList.addAll(
      await ApiService.sendMessage(message: msg, modelId: model),
    );
    notifyListeners();
  }
}
