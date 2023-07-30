import 'package:flutter/material.dart';

class LetterTileClear extends StatelessWidget {
  static const double tileSize = 50;
  final void Function() onCLear;

  const LetterTileClear({super.key, required this.onCLear});

  @override
  Widget build(BuildContext context) {
    const tileBgColor = Color(0x00000000);
    const tileColor = Color(0xff7f8c8d);
    const double iconSize = 36;

    return GestureDetector(
        onTap: onCLear,
        child: Container(
            width: tileSize,
            height: tileSize,
            decoration: BoxDecoration(
                color: tileBgColor,
                border: Border.all(color: tileColor, width: 3),
                borderRadius:
                    const BorderRadiusDirectional.all(Radius.circular(10))),
            child: const Center(
              child: Icon(
                Icons.clear,
                color: tileColor,
                size: iconSize,
                semanticLabel: 'éffacer',
              ),
            )));
  }
}
