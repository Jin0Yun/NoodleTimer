import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';

class CookHistoryEntity {
  final String ramenId;
  final DateTime cookedAt;
  final NoodlePreference noodleState;
  final Duration cookTime;

  const CookHistoryEntity({
    required this.ramenId,
    required this.cookedAt,
    required this.noodleState,
    required this.cookTime,
  });

  factory CookHistoryEntity.fromMap(Map<String, dynamic> map) {
    return CookHistoryEntity(
      ramenId: map['ramenId'],
      cookedAt: (map['cookedAt'] as Timestamp).toDate(),
      noodleState: NoodlePreferenceMapper.from(map['noodleState']),
      cookTime: Duration(seconds: map['cookTime'] ?? 180),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ramenId': ramenId,
      'cookedAt': cookedAt,
      'noodleState': noodleState.toShortString(),
      'cookTime': cookTime.inSeconds,
    };
  }
}
