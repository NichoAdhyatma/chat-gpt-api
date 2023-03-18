import 'package:chat_gpt/constants/constant.dart';
import 'package:chat_gpt/models/chat.dart';
import 'package:chat_gpt/providers/models_provider.dart';
import 'package:chat_gpt/services/api_service.dart';
import 'package:chat_gpt/services/asset_service.dart';
import 'package:chat_gpt/services/services.dart';
import 'package:chat_gpt/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isTyping = false;
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> sendMessage(ModelsProvider modelProvider) async {
    var message = textEditingController.text;
    setState(() {
      isTyping = true;
      chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
      textEditingController.clear();
      focusNode.unfocus();
    });
    try {
      chatList.addAll(
        await ApiService.sendMessage(
          message: message,
          modelId: modelProvider.getCurrentModels,
        ),
      );
      textEditingController.clear();
      setState(() {});
    } catch (err) {
      print(err);
    } finally {
      setState(() {
        isTyping = false;
      });
    }
  }

  List<ChatModel> chatList = [];

  @override
  Widget build(BuildContext context) {
    var modelProvider = Provider.of<ModelsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            AssetService.openaiLogo,
          ),
        ),
        title: const Text("Chat GPT Demo"),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showBottomModal(context);
            },
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    text: chatList[index].msg,
                    index: chatList[index].chatIndex,
                  );
                },
              ),
            ),
            if (isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
            const SizedBox(
              height: 15,
            ),
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        style: const TextStyle(color: Colors.white),
                        controller: textEditingController,
                        decoration: const InputDecoration.collapsed(
                          hintText: "How i can help you ?",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await sendMessage(modelProvider);
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
