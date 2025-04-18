import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noodle_timer/domain/entity/egg_preference.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';

class CookHistoryEntity {
  final String id;
  final String ramenId;
  final String? ramenName;
  final String? ramenImage;
  final DateTime cookedAt;
  final NoodlePreference noodleState;
  final EggPreference eggPreference;
  final Duration cookTime;

  const CookHistoryEntity({
    this.id = '',
    required this.ramenId,
    this.ramenName,
    this.ramenImage,
    required this.cookedAt,
    required this.noodleState,
    required this.eggPreference,
    required this.cookTime,
  });

  factory CookHistoryEntity.fromMap(Map<String, dynamic> map) {
    return CookHistoryEntity(
      id: map['id'] ?? '',
      ramenId: map['ramenId'],
      ramenName: map['ramenName'],
      ramenImage: map['ramenImageUrl'],
      cookedAt: (map['cookedAt'] as Timestamp).toDate(),
      noodleState: NoodlePreferenceX.from(map['noodleState']),
      eggPreference: EggPreferenceX.from(map['eggPreference']),
      cookTime: Duration(seconds: map['cookTime'] ?? 180),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ramenId': ramenId,
      'ramenName': ramenName,
      'ramenImage': ramenImage,
      'cookedAt': cookedAt,
      'noodleState': noodleState.name,
      'eggPreference': eggPreference.name,
      'cookTime': cookTime.inSeconds,
    };
  }

  CookHistoryEntity withRamenInfo(String name, String image) {
    return CookHistoryEntity(
      id: id,
      ramenId: ramenId,
      ramenName: name,
      ramenImage: image,
      cookedAt: cookedAt,
      noodleState: noodleState,
      eggPreference: eggPreference,
      cookTime: cookTime,
    );
  }

  String get displayName => ramenName ?? '알 수 없는 라면';
}