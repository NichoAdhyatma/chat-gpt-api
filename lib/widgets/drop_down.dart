import 'package:chat_gpt/constants/constant.dart';
import 'package:chat_gpt/models/models.dart';
import 'package:chat_gpt/services/api_service.dart';
import 'package:flutter/material.dart';

class DropdownWidget extends StatefulWidget {
  const DropdownWidget({super.key});

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  String currentModel = "text-davinci-003";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Models>>(
      future: ApiService.getModels(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("${snapshot.error}"),
          );
        }
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        } else {
          return FittedBox(
            child: DropdownButton(
              dropdownColor: scaffoldBackgroundColor,
              items: List<DropdownMenuItem<String>>.generate(
                snapshot.data!.length,
                (index) => DropdownMenuItem(
                  value: snapshot.data![index].id,
                  child: Text(
                    snapshot.data![index].id,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              value: currentModel,
              onChanged: (value) {
                setState(
                  () {
                    currentModel = value.toString();
                  },
                );
              },
            ),
          );
        }
      },
    );
  }
}

/*
 
*/
