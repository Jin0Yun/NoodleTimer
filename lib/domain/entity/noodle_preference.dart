enum NoodlePreference { kodul, peojin, none }

extension NoodlePreferenceX on NoodlePreference {
  static NoodlePreference from(String? value) {
    final parsed = value?.split('.').last;
    return NoodlePreference.values.firstWhere((e) => e.name == parsed,
        orElse: () => NoodlePreference.none);
  }

  String get short => name;

  String get displayText {
    switch (this) {
      case NoodlePreference.kodul:
        return '꼬들면';
      case NoodlePreference.peojin:
        return '퍼진면';
      case NoodlePreference.none:
        return '기본';
    }
  }
}