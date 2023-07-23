import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrabble_dico/widgets/letter_tile_input_field.dart';

const appTitle = 'Dictionnaire SCRABBLE';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    final bgColor =
        isDarkMode ? const Color(0xff000000) : const Color(0xffffffff);

    final home = Container(
        color: bgColor,
        child: const SafeArea(
            child: Center(
          child: Row(
            children: [
              Spacer(),
              LetterTileInputField(initalText: 'INPUT'),
              Spacer()
            ],
          ),
        )));

    if (Platform.isIOS) {
      return CupertinoApp(title: appTitle, home: home);
    } else {
      return MaterialApp(title: appTitle, home: home);
    }
  }
}
