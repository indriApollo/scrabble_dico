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
