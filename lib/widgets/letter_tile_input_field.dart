import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:scrabble_dico/application.dart';

import 'letter_tile.dart';

class LetterTileInputField extends StatefulWidget {
  final String initalText;

  const LetterTileInputField({super.key, this.initalText = ''});

  @override
  State<LetterTileInputField> createState() => _LetterTileInputFieldState();
}

class _LetterTileInputFieldState extends State<LetterTileInputField> {
  static const double _tileSpacing = 4;
  static const double _tileSize = LetterTile.tileSize + (_tileSpacing * 2);

  late String _inputText;
  late final FocusNode _node;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _inputText = widget.initalText;
    _node = FocusNode();
    _controller = TextEditingController();
    _controller.addListener(_handleTextInput);
  }

  @override
  void dispose() {
    _node.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_node.hasFocus) {
      _node.unfocus();
    } else {
      _node.requestFocus();
    }
  }

  void _handleTextInput() {
    setState(() {
      _inputText = _controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    const lightGray = Color(0xffecf0f1);
    const noColor = Color(0x00000000);

    return GestureDetector(
        onTap: _handleTap,
        child: Stack(children: [
          Container(
              constraints: const BoxConstraints(
                  minHeight: _tileSize,
                  minWidth: _tileSize * 3,
                  maxWidth: _tileSize * 7),
              padding: const EdgeInsets.all(_tileSpacing),
              decoration: const BoxDecoration(
                  color: lightGray,
                  borderRadius:
                      BorderRadiusDirectional.all(Radius.circular(12))),
              child: Wrap(
                spacing: _tileSpacing,
                runSpacing: _tileSpacing,
                alignment: WrapAlignment.center,
                children: _inputText.characters
                    .map((c) => _letterTileByCharacter(c))
                    .toList(),
              )),
          SizedBox(
              width: 0,
              height: 0,
              child: EditableText(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                    LengthLimitingTextInputFormatter(15)
                  ],
                  autocorrect: false,
                  enableSuggestions: false,
                  controller: _controller,
                  focusNode: _node,
                  style: const TextStyle(color: noColor, fontSize: 0),
                  showCursor: false,
                  cursorColor: noColor,
                  backgroundCursorColor: noColor)),
        ]));
  }

  Widget _letterTileByCharacter(String character) {
    final l = Letter.fromCharacter(character);
    return LetterTile(character: l.character, points: l.points);
  }
}
