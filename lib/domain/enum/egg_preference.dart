enum EggPreference { none, half, full }

extension EggPreferenceX on EggPreference {
  static EggPreference from(String? value) {
    final parsed = value?.split('.').last;
    return EggPreference.values.firstWhere(
      (e) => e.name == parsed,
      orElse: () => EggPreference.none,
    );
  }

  String get short => name;

  String get displayText {
    switch (this) {
      case EggPreference.half:
        return '반숙';
      case EggPreference.full:
        return '완숙';
      case EggPreference.none:
        return '없음';
    }
  }
}