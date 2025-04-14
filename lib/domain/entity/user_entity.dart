import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noodle_timer/domain/entity/cook_history_entity.dart';
import 'package:noodle_timer/domain/entity/egg_preference.dart';
import 'package:noodle_timer/domain/entity/noodle_preference.dart';

class UserEntity {
  final String uid;
  final String email;
  final List<String> favoriteRamenIds;
  final NoodlePreference noodlePreference;
  final EggPreference eggPreference;
  final List<CookHistoryEntity> cookHistories;
  final DateTime createdAt;

  UserEntity({
    required this.uid,
    required this.email,
    required this.favoriteRamenIds,
    required this.noodlePreference,
    required this.eggPreference,
    required this.cookHistories,
    required this.createdAt,
  });

  factory UserEntity.fromMap(Map<String, dynamic> data) {
    return UserEntity(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      favoriteRamenIds: List<String>.from(data['favoriteRamenIds'] ?? []),
      noodlePreference: NoodlePreferenceMapper.from(data['noodlePreference'] ?? 'peojin'),
      eggPreference: EggPreferenceMapper.from(data['eggPreference'] ?? 'none'),
      cookHistories: List<CookHistoryEntity>.from(
          (data['cookHistories'] ?? []).map((item) => CookHistoryEntity.fromMap(item))),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'favoriteRamenIds': favoriteRamenIds,
      'noodlePreference': noodlePreference.toShortString(),
      'eggPreference': eggPreference.toShortString(),
      'cookHistories': cookHistories.map((e) => e.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}