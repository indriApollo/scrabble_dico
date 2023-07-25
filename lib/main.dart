import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrabble_dico/application.dart';
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
        child: SafeArea(
            child: AppInitializer(
                appInit: Db.init(),
                loadingMessage: 'Chargement ...',
                child: const Column(
                  children: [LetterTileInputField(initalText: 'MOTS')],
                ))));

    if (Platform.isIOS) {
      return CupertinoApp(title: appTitle, home: home);
    } else {
      return MaterialApp(title: appTitle, home: home);
    }
  }
}

class AppInitializer extends StatefulWidget {
  final Future<void>? appInit;
  final String loadingMessage;
  final Widget child;

  const AppInitializer(
      {super.key,
      required this.appInit,
      required this.loadingMessage,
      required this.child});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late final Future<void>? _appInit;

  @override
  void initState() {
    super.initState();
    _appInit = widget.appInit;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.displayMedium!,
      textAlign: TextAlign.center,
      child: FutureBuilder<void>(
        future: _appInit,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          String text;

          if (snapshot.connectionState == ConnectionState.done) {
            return widget.child;
          } else if (snapshot.hasError) {
            text = snapshot.error.toString();
          } else {
            text = widget.loadingMessage;
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(text, key: Key(text))],
            ),
          );
        },
      ),
    );
  }
}
