import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noodle_timer/domain/enum/egg_preference.dart';
import 'package:noodle_timer/domain/enum/noodle_preference.dart';

class CookHistoryEntity {
  final String id;
  final int ramenId;
  final String ramenName;
  final String ramenImageUrl;
  final DateTime cookedAt;
  final NoodlePreference noodleState;
  final EggPreference eggPreference;
  final Duration cookTime;

  const CookHistoryEntity({
    this.id = '',
    required this.ramenId,
    required this.ramenName,
    required this.ramenImageUrl,
    required this.cookedAt,
    required this.noodleState,
    required this.eggPreference,
    required this.cookTime
  });

  factory CookHistoryEntity.fromMap(Map<String, dynamic> map) {
    return CookHistoryEntity(
      id: map['id'] ?? '',
      ramenId: map['ramenId'] ?? 0,
      ramenName: map['ramenName'] ?? '',
      ramenImageUrl: map['ramenImageUrl'] ?? '',
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
      'ramenImageUrl': ramenImageUrl,
      'cookedAt': Timestamp.fromDate(cookedAt),
      'noodleState': noodleState.name,
      'eggPreference': eggPreference.name,
      'cookTime': cookTime.inSeconds,
    };
  }

  CookHistoryEntity copyWith({
    String? id,
    int? ramenId,
    String? ramenName,
    String? ramenImageUrl,
    DateTime? cookedAt,
    NoodlePreference? noodleState,
    EggPreference? eggPreference,
    Duration? cookTime,
    String? note,
  }) {
    return CookHistoryEntity(
      id: id ?? this.id,
      ramenId: ramenId ?? this.ramenId,
      ramenName: ramenName ?? this.ramenName,
      ramenImageUrl: ramenImageUrl ?? this.ramenImageUrl,
      cookedAt: cookedAt ?? this.cookedAt,
      noodleState: noodleState ?? this.noodleState,
      eggPreference: eggPreference ?? this.eggPreference,
      cookTime: cookTime ?? this.cookTime,
    );
  }

  String get displayName => ramenName.isNotEmpty ? ramenName : '알 수 없는 라면';

  String get formattedCookTime {
    final minutes = cookTime.inMinutes;
    final seconds = cookTime.inSeconds % 60;
    return '$minutes분 $seconds초';
  }
}