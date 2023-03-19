import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_gpt/constants/constant.dart';
import 'package:chat_gpt/services/asset_service.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.text, required this.index});

  final String text;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: index == 0 ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: index == 0
                          ? NetworkImage(AssetService.userProfile)
                          : NetworkImage(AssetService.botProfile),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: index == 0
                      ? Text(
                          text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        )
                      : DefaultTextStyle(
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                          child: AnimatedTextKit(
                            repeatForever: false,
                            displayFullTextOnTap: false,
                            isRepeatingAnimation: false,
                            totalRepeatCount: 1,
                            animatedTexts: [
                              TyperAnimatedText(
                                text.trim(),
                              ),
                            ],
                          ),
                        ),
                ),
                index == 0
                    ? const SizedBox.shrink()
                    : Row(
                        children: const [
                          Icon(
                            Icons.thumb_up_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.thumb_down_outlined,
                            color: Colors.white,
                          ),
                        ],
                      )
              ],
            ),
          ),
        )
      ],
    );
  }
}
