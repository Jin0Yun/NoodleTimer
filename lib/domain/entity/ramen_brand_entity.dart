import 'ramen_entity.dart';

class RamenBrandEntity {
  final int id;
  final String name;
  final List<RamenEntity> ramens;

  const RamenBrandEntity({
    required this.id,
    required this.name,
    required this.ramens,
  });

  RamenBrandEntity copyWith({
    int? id,
    String? name,
    List<RamenEntity>? ramens,
  }) {
    return RamenBrandEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      ramens: ramens ?? this.ramens,
    );
  }

  int get ramenCount => ramens.length;
  List<RamenEntity> get spicyRamens => ramens.where((r) => r.isSpicy).toList();
  List<RamenEntity> get mildRamens => ramens.where((r) => !r.isSpicy).toList();
}