import 'package:chat_gpt/constants/constant.dart';
import 'package:chat_gpt/models/models.dart';
import 'package:chat_gpt/providers/models_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropdownWidget extends StatefulWidget {
  const DropdownWidget({super.key});

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  String? currentModel;

  @override
  Widget build(BuildContext context) {
    var modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
    currentModel = modelsProvider.getCurrentModels;
    return FutureBuilder<List<Models>>(
      future: modelsProvider.getAllModels(),
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
                modelsProvider.setCurrentModels(value.toString());
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
