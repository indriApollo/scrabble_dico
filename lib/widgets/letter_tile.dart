import 'package:flutter/widgets.dart';

class LetterTile extends StatelessWidget {
  static const double tileSize = 50;

  final String character;
  final int points;

  const LetterTile({required this.character, required this.points, super.key});

  @override
  Widget build(BuildContext context) {
    const tileBgColor = Color(0xffffc107);
    const tileBorderColor = Color(0xfffd7e14);
    const double letterFontSize = 36;
    const double pointsFontSize = 10;

    return Stack(alignment: Alignment.bottomRight, children: [
      Container(
          width: tileSize,
          height: tileSize,
          decoration: BoxDecoration(
              color: tileBgColor,
              border: Border.all(color: tileBorderColor, width: 3),
              borderRadius:
                  const BorderRadiusDirectional.all(Radius.circular(10))),
          child: Center(
              child: Text(character,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: letterFontSize)))),
      Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 6, 4),
        child: Text(points.toString(),
            style: const TextStyle(fontSize: pointsFontSize),
            textAlign: TextAlign.left),
      )
    ]);
  }
}
