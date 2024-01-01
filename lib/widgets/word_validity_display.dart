import 'package:flutter/widgets.dart';

class WordValidityDisplay extends StatelessWidget {
  final String word;
  final bool isValid;

  const WordValidityDisplay(
      {super.key, required this.word, required this.isValid});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Le mot $word est ${isValid ? 'valide' : 'invalide'}',
      style: TextStyle(
          color: isValid ? const Color(0xff00ff00) : const Color(0xffff0000)),
    );
  }
}
