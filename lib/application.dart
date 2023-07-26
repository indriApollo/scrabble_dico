import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:crypto/crypto.dart';

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
  static const dbMD5 = 'c7e5969c8046582d401468b04f8868b3';
  static const dbName = 'db.sqlite';
  static late Database _conn;

  static Future<void> init() async {
    final appSupportDir = await getApplicationSupportDirectory();
    final dbStorageFile = File('${appSupportDir.path}/$dbName');

    if (!await _dbExistsAndIsValid(dbStorageFile)) {
      await _copyDbFromAssets(dbStorageFile);
    }

    _conn = sqlite3.open(dbStorageFile.path, mode: OpenMode.readOnly);
  }

  static bool isWordValid(String word) {
    var result = _conn.select("SELECT 1 FROM words WHERE word = ?;", [word]);
    return result.isNotEmpty;
  }

  static Future<bool> _dbExistsAndIsValid(File dbStorageFile) async {
    if (!await dbStorageFile.exists()) return false;

    debugPrint('db file found at <${dbStorageFile.path}>');

    // verify db file checksum
    // Could be wrong if app was killed before copy was complete
    // or db is an older version
    return await _md5Match(dbStorageFile, dbMD5);
  }

  static Future<void> _copyDbFromAssets(File dbStorageFile) async {
    const dbAssetPath = 'assets/$dbName.zlib';

    debugPrint(
        'copying and uncompressing db from <$dbAssetPath> to <${dbStorageFile.path}>');

    final sw = Stopwatch();
    sw.start();

    var decoder = ZLibDecoder();

    ByteData data = await rootBundle.load(dbAssetPath);
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await dbStorageFile.writeAsBytes(decoder.convert(bytes), flush: true);

    sw.stop();

    debugPrint('db copy done in <${sw.elapsedMilliseconds}> ms');

    if (!await _md5Match(dbStorageFile, dbMD5)) {
      throw Exception("_copyDbFromAssets checksum failed");
    }
  }

  static Future<bool> _md5Match(File file, String expectedHash) async {
    final stream = file.openRead();
    final hash = await md5.bind(stream).first;
    final hashHex =
        hash.bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

    if (hashHex != expectedHash) {
      debugPrint(
          'mismatched md5 file <${file.path}> expected <$expectedHash> actual <$hashHex>');
      return false;
    }

    return true;
  }
}
