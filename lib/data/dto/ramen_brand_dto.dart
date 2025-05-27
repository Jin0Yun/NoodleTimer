import 'package:noodle_timer/data/dto/ramen_dto.dart';
import 'package:noodle_timer/domain/entity/ramen_brand_entity.dart';

class RamenBrandDTO {
  final int id;
  final String name;
  final List<RamenDTO> ramens;

  RamenBrandDTO({required this.id, required this.name, required this.ramens});

  factory RamenBrandDTO.fromJson(Map<String, dynamic> json) {
    final ramenList =
        (json['ramens'] as List)
            .map((ramenJson) => RamenDTO.fromJson(ramenJson))
            .toList();

    return RamenBrandDTO(
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
