enum NoodlePreference { kodul, peojin, none }

extension NoodlePreferenceMapper on NoodlePreference {
  static NoodlePreference from(String? value) {
    switch (value) {
      case 'peojin':
        return NoodlePreference.peojin;
      case 'kodul':
        return NoodlePreference.kodul;
      default:
        return NoodlePreference.none;
    }
  }

  String toShortString() => name;
}
