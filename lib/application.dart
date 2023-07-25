import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

class Letter {
  final String character;
  final int points;

  const Letter(this.character, this.points);

  factory Letter.fromCharacter(String character) {
    final pointsWithCharacters = {
      1: {'E', 'A', 'I', 'N', 'O', 'R', 'S', 'T', 'U', 'L'},
      2: {'D', 'G', 'M'},
      3: {'B', 'C', 'P'},
      4: {'F', 'H', 'V'},
      8: {'J', 'Q'},
      10: {'K', 'W', 'X', 'Y', 'Z'}
    };

    character = character.toUpperCase();

    for (final pwc in pointsWithCharacters.entries) {
      final points = pwc.key;
      final characters = pwc.value;

      if (characters.contains(character)) {
        return Letter(character, points);
      }
    }

    throw Exception('invalid character $character');
  }
}

class Db {
  static const dbName = 'db.sqlite';
  static late String dbStoragePath;

  static Future<void> init() async {
    const assetsDir = 'assets';

    // check if already copied to storage
    if (await File(dbName).exists()) return;

    // copy db from assets to storage
    ByteData data = await rootBundle.load('$assetsDir/$dbName');
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    var appSupportDir = await getApplicationSupportDirectory();
    await File('${appSupportDir.path}/$dbName')
        .writeAsBytes(bytes, flush: true);
  }

  static bool isWordValid(String word) {
    final db = sqlite3.open(dbStoragePath, mode: OpenMode.readOnly);

    var result = db.select("SELECT 1 FROM words WHERE word = ?;", [word]);
    return result.isNotEmpty;
  }
}
