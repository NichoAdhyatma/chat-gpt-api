import 'package:chat_gpt/widgets/drop_down.dart';
import 'package:flutter/material.dart';

import '../constants/constant.dart';

class Services {
  static Future<void> showBottomModal(BuildContext context) async {
    return showModalBottomSheet(
      backgroundColor: scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Choose Model",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 2,
              child: DropdownWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
