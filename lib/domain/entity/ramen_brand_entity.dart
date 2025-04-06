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
}
