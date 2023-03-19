import 'package:chat_gpt/constants/constant.dart';
import 'package:chat_gpt/models/chat.dart';
import 'package:chat_gpt/providers/chat_provider.dart';
import 'package:chat_gpt/providers/models_provider.dart';
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
  bool canSend = false;
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  ScrollController listController = ScrollController();

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    listController.dispose();
    super.dispose();
  }

  Future<void> sendMessage(
      ModelsProvider modelProvider, ChatProvider chatProvider) async {
    var message = textEditingController.text;
    setState(() {
      isTyping = true;
      chatProvider.addUserChat(message);
      textEditingController.clear();
      canSend = false;
      focusNode.unfocus();
    });
    try {
      await chatProvider.addAiChat(message, modelProvider.getCurrentModels);
      setState(() {});
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "$err",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        scrollToEnd();
        isTyping = false;
      });
    }
  }

  void scrollToEnd() {
    listController.animateTo(
      listController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }

  List<ChatModel> chatList = [];

  @override
  Widget build(BuildContext context) {
    var modelProvider = Provider.of<ModelsProvider>(context);
    var chatProvider = Provider.of<ChatProvider>(context);

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
                controller: listController,
                itemCount: chatProvider.getChatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    text: chatProvider.getChatList[index].msg,
                    index: chatProvider.getChatList[index].chatIndex,
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
                        onChanged: (_) {
                          setState(() {
                            textEditingController.text.isNotEmpty
                                ? canSend = true
                                : canSend = false;
                          });
                        },
                        onEditingComplete: () async {
                          await sendMessage(modelProvider, chatProvider);
                        },
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
                    canSend
                        ? IconButton(
                            onPressed: () async {
                              await sendMessage(modelProvider, chatProvider);
                            },
                            icon: const Icon(
                              Icons.send,
                              color: Colors.grey,
                            ),
                          )
                        : const SizedBox(height: 48),
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
