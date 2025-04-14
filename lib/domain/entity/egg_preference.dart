enum EggPreference { none, half, full }

extension EggPreferenceMapper on EggPreference {
  static EggPreference from(String? value) {
    switch (value) {
      case 'half':
        return EggPreference.half;
      case 'full':
        return EggPreference.full;
      case 'none':
      default:
        return EggPreference.none;
    }
  }

  String toShortString() => name;
}
