import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noodle_timer/domain/entity/egg_preference.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';

class CookHistoryEntity {
  final String ramenId;
  final DateTime cookedAt;
  final NoodlePreference noodleState;
  final EggPreference eggPreference;
  final Duration cookTime;

  const CookHistoryEntity({
    required this.ramenId,
    required this.cookedAt,
    required this.noodleState,
    required this.eggPreference,
    required this.cookTime,
  });

  factory CookHistoryEntity.fromMap(Map<String, dynamic> map) {
    return CookHistoryEntity(
      ramenId: map['ramenId'],
      cookedAt: (map['cookedAt'] as Timestamp).toDate(),
      noodleState: NoodlePreferenceX.from(map['noodleState']),
      eggPreference: EggPreferenceX.from(map['eggPreference']),
      cookTime: Duration(seconds: map['cookTime'] ?? 180),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ramenId': ramenId,
      'cookedAt': cookedAt,
      'noodleState': noodleState.toString(),
      'eggPreference': eggPreference.toString(),
      'cookTime': cookTime.inSeconds,
    };
  }
}
