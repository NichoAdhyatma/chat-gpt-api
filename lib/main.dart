import 'package:chat_gpt/constants/constant.dart';
import 'package:chat_gpt/screens/chat_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const GptChat());

class GptChat extends StatelessWidget {
  const GptChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat GPT demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        appBarTheme: const AppBarTheme(
          color: cardColor,
        ),
      ),
      home: const ChatScreen(),
    );
  }
}
