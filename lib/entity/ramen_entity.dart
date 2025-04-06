class RamenEntity {
  final int id;
  final String name;
  final String imageUrl;
  final String spicyLevel;
  final String description;
  final String recipe;
  final bool afterSeasoning;

  const RamenEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.spicyLevel,
    required this.description,
    required this.recipe,
    required this.afterSeasoning,
  });
}
