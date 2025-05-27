class RamenEntity {
  final int id;
  final String name;
  final String imageUrl;
  final String spicyLevel;
  final String description;
  final String recipe;
  final bool afterSeasoning;
  final int cookTime;

  const RamenEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.spicyLevel,
    required this.description,
    required this.recipe,
    required this.afterSeasoning,
    required this.cookTime
  });

  RamenEntity copyWith({
    int? id,
    String? name,
    String? imageUrl,
    String? spicyLevel,
    String? description,
    String? recipe,
    bool? afterSeasoning,
    int? cookTime,
  }) {
    return RamenEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      spicyLevel: spicyLevel ?? this.spicyLevel,
      description: description ?? this.description,
      recipe: recipe ?? this.recipe,
      afterSeasoning: afterSeasoning ?? this.afterSeasoning,
      cookTime: cookTime ?? this.cookTime,
    );
  }

  String get formattedCookTime {
    final minutes = cookTime ~/ 60;
    final seconds = cookTime % 60;
    return '$minutes분 $seconds초';
  }

  bool get isSpicy => spicyLevel.contains('매운');
}