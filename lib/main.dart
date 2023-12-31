import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrabble_dico/application.dart';
import 'package:scrabble_dico/widgets/letter_tile_input_field.dart';
import 'package:scrabble_dico/widgets/word_validity_display.dart';

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
        child: const AppInitializer(
            loadingMessage: 'Chargement ...', child: HomeView()));

    if (Platform.isIOS) {
      return CupertinoApp(title: appTitle, home: home);
    } else {
      return MaterialApp(title: appTitle, home: home);
    }
  }
}

class AppInitializer extends StatefulWidget {
  final String loadingMessage;
  final Widget child;

  const AppInitializer(
      {super.key, required this.loadingMessage, required this.child});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late final Future<void>? _appInit;

  @override
  void initState() {
    super.initState();
    _appInit = Db.init();
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

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _text = 'MOTS';
  bool _isValid = true;

  void _handleOnSubmitted(String text) {
    setState(() {
      _text = text.toUpperCase();
      _isValid = Db.isWordValid(_text);
    });
  }

  void _handleOnClear() {
    setState(() {
      _text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 1),
        LetterTileInputField(
            initalText: 'MOTS', onSubmitted: _handleOnSubmitted, onCLear: _handleOnClear),
        const Spacer(flex: 1),
        _validityDisplay(),
        const Spacer(flex: 2),
      ],
    );
  }

  Widget _validityDisplay() {
    if (_text.isNotEmpty) {
      return WordValidityDisplay(word: _text, isValid: _isValid);
    } else {
      return const Text("Tapez un mot");
    }
  }
}
