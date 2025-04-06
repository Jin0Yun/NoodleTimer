import 'package:noodle_timer/data/dto/ramen.dart';
import 'package:noodle_timer/domain/entity/ramen_brand_entity.dart';

class RamenBrand {
  final int id;
  final String name;
  final List<Ramen> ramens;

  RamenBrand({required this.id, required this.name, required this.ramens});

  factory RamenBrand.fromJson(Map<String, dynamic> json) {
    final ramenList =
        (json['ramens'] as List)
            .map((ramenJson) => Ramen.fromJson(ramenJson))
            .toList();

    return RamenBrand(
      id: json['brandId'],
      name: json['brandName'],
      ramens: ramenList,
    );
  }

  RamenBrandEntity toEntity() {
    return RamenBrandEntity(
      id: id,
      name: name,
      ramens: ramens.map((e) => e.toEntity()).toList(),
    );
  }
}
