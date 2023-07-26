// ignore_for_file: avoid_print

import 'dart:io';

void main(List<String> arguments) async {
  String filePath = arguments[0];
  await compressFile(File(filePath), File('$filePath.zlib'));
}

Future<void> compressFile(File inputFile, File outputFile) async {
  try {
    var encoder = ZLibEncoder();

    await inputFile.openRead().transform(encoder).pipe(outputFile.openWrite());

    print('File compressed successfully!');
  } catch (e) {
    print('Error while compressing the file: $e');
  }
}
