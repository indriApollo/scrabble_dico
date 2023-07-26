import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:scrabble_dico/application.dart';

import 'letter_tile.dart';

class LetterTileInputField extends StatefulWidget {
  final String initalText;
  final ValueChanged<String>? onSubmitted;

  const LetterTileInputField(
      {super.key, this.initalText = '', this.onSubmitted});

  @override
  State<LetterTileInputField> createState() => _LetterTileInputFieldState();
}

class _LetterTileInputFieldState extends State<LetterTileInputField> {
  static const double _inputPading = 6;
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

  void _handleTap({required bool inside}) {
    if (_node.hasFocus) {
      _node.unfocus();
    } else if (inside) {
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

    return TapRegion(
        onTapInside: (_) => _handleTap(inside: true),
        onTapOutside: (_) => _handleTap(inside: false),
        child: Stack(children: [
          Container(
              constraints: const BoxConstraints(
                  minHeight: _tileSize, minWidth: _tileSize * 3),
              padding: const EdgeInsets.all(_inputPading),
              decoration: const BoxDecoration(
                  color: lightGray,
                  borderRadius: BorderRadiusDirectional.all(
                      Radius.circular(10 + _inputPading))),
              child: Wrap(
                spacing: _tileSpacing,
                runSpacing: _tileSpacing,
                alignment: WrapAlignment.center,
                children: _inputText.characters
                    .map((c) => _letterTileByCharacter(c))
                    .toList(),
              )),
          ShadowEditableText(
              textEditingController: _controller,
              focusNode: _node,
              onSubmitted: widget.onSubmitted,
              textFilter: RegExp('[a-zA-Z]'),
              maxTextLength: 15)
        ]));
  }

  Widget _letterTileByCharacter(String character) {
    final l = Letter.fromCharacter(character);
    return LetterTile(character: l.character, points: l.points);
  }
}

class ShadowEditableText extends StatelessWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final ValueChanged<String>? onSubmitted;
  final Pattern textFilter;
  final int? maxTextLength;

  const ShadowEditableText(
      {super.key,
      required this.textEditingController,
      required this.focusNode,
      required this.onSubmitted,
      required this.textFilter,
      this.maxTextLength});

  @override
  Widget build(BuildContext context) {
    const noColor = Color(0x00000000);

    return SizedBox(
        width: 0,
        height: 0,
        child: EditableText(
            onSubmitted: onSubmitted,
            inputFormatters: [
              FilteringTextInputFormatter.allow(textFilter),
              LengthLimitingTextInputFormatter(maxTextLength)
            ],
            autocorrect: false,
            enableSuggestions: false,
            controller: textEditingController,
            focusNode: focusNode,
            style: const TextStyle(color: noColor, fontSize: 0),
            showCursor: false,
            cursorColor: noColor,
            backgroundCursorColor: noColor));
  }
}
