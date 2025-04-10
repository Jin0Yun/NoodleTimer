class HangulUtils {
  static const List<String> _choSung = [
    'ㄱ',
    'ㄲ',
    'ㄴ',
    'ㄷ',
    'ㄸ',
    'ㄹ',
    'ㅁ',
    'ㅂ',
    'ㅃ',
    'ㅅ',
    'ㅆ',
    'ㅇ',
    'ㅈ',
    'ㅉ',
    'ㅊ',
    'ㅋ',
    'ㅌ',
    'ㅍ',
    'ㅎ',
  ];

  static String extractChoSung(String text) {
    StringBuffer result = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      int unicode = text.codeUnitAt(i);

      if (unicode >= 0xAC00 && unicode <= 0xD7A3) {
        int choSungIndex = ((unicode - 0xAC00) / 28 / 21).floor();
        if (choSungIndex >= 0 && choSungIndex < _choSung.length) {
          result.write(_choSung[choSungIndex]);
        }
      } else {
        result.write(text[i]);
      }
    }
    return result.toString();
  }

  static bool isChoSungOnly(String keyword) {
    return keyword.split('').every(_choSung.contains);
  }

  static bool matchesChoSung(String text, String keyword) {
    if (keyword.isEmpty) return false;
    if (isChoSungOnly(keyword)) {
      final choSung = extractChoSung(text);
      return choSung.contains(keyword);
    }
    return text.contains(keyword);
  }
}
