import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noodle_timer/domain/enum/egg_preference.dart';
import 'package:noodle_timer/domain/enum/noodle_preference.dart';

class UserEntity {
  final String uid;
  final String email;
  final List<int> favoriteRamenIds;
  final NoodlePreference noodlePreference;
  final EggPreference eggPreference;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  UserEntity({
    required this.uid,
    required this.email,
    required this.favoriteRamenIds,
    required this.noodlePreference,
    required this.eggPreference,
    required this.createdAt,
    this.lastLoginAt
  });

  factory UserEntity.fromMap(Map<String, dynamic> data) {
    return UserEntity(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      favoriteRamenIds: List<int>.from(data['favoriteRamenIds'] ?? []),
      noodlePreference: NoodlePreferenceX.from(
        data['noodlePreference'] ?? 'none',
      ),
      eggPreference: EggPreferenceX.from(data['eggPreference'] ?? 'none'),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastLoginAt:
          data['lastLoginAt'] != null
              ? (data['lastLoginAt'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'favoriteRamenIds': favoriteRamenIds,
      'noodlePreference': noodlePreference.name,
      'eggPreference': eggPreference.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt':
          lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
    };
  }

  UserEntity copyWith({
    String? uid,
    String? email,
    String? nickname,
    List<int>? favoriteRamenIds,
    NoodlePreference? noodlePreference,
    EggPreference? eggPreference,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    int? totalCookCount,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      favoriteRamenIds: favoriteRamenIds ?? this.favoriteRamenIds,
      noodlePreference: noodlePreference ?? this.noodlePreference,
      eggPreference: eggPreference ?? this.eggPreference,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}