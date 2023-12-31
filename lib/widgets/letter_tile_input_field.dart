import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scrabble_dico/application.dart';
import 'package:scrabble_dico/widgets/letter_tile_clear.dart';
import 'package:scrabble_dico/widgets/shadow_editable_text.dart';

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
  static const double _tileSpacing = 4;
  static const double _tileTotalSpacing = _tileSpacing * 2;

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

  void _handleTextInputClear() {
    setState(() {
      _controller.clear();
      //_inputText = _controller.text;
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
                  minHeight: LetterTile.tileSize + _tileTotalSpacing, minWidth: (LetterTile.tileSize * 3) + (_tileTotalSpacing * 2)),
              padding: const EdgeInsets.all(_tileSpacing),
              decoration: const BoxDecoration(
                  color: lightGray,
                  borderRadius: BorderRadiusDirectional.all(
                      Radius.circular(10 + _tileSpacing))),
              child: Wrap(
                  spacing: _tileSpacing,
                  runSpacing: _tileSpacing,
                  alignment: WrapAlignment.center,
                  children: _inputContent(_inputText.characters))),
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

  List<Widget> _inputContent(Characters characters) {
    var l = characters.map((c) => _letterTileByCharacter(c)).toList();
    if (l.isNotEmpty) l.add(LetterTileClear(onCLear: _handleTextInputClear));
    return l;
  }
}
