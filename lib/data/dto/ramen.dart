import 'package:noodle_timer/domain/entity/ramen_entity.dart';

class Ramen {
  final int id;
  final String name;
  final String imageUrl;
  final String spicyLevel;
  final String description;
  final String recipe;
  final bool afterSeasoning;
  final int cookTime;

  Ramen({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.spicyLevel,
    required this.description,
    required this.recipe,
    required this.afterSeasoning,
    required this.cookTime,
  });

  factory Ramen.fromJson(Map<String, dynamic> json) {
    return Ramen(
      id: json['ramenIndex'],
      name: json['ramenName'],
      imageUrl: json['ramenImage'],
      spicyLevel: json['ramenSpicy'],
      description: json['ramenDescription'],
      recipe: json['ramenRecipe'],
      afterSeasoning: json['afterSeasoning'],
      cookTime: json['cookTime'],
    );
  }

  RamenEntity toEntity() {
    return RamenEntity(
      id: id,
      name: name,
      imageUrl: imageUrl,
      spicyLevel: spicyLevel,
      description: description,
      recipe: recipe,
      afterSeasoning: afterSeasoning,
      cookTime: cookTime,
    );
  }
}
