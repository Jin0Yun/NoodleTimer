import 'package:noodle_timer/data/dto/ramen_brand_dto.dart';
import 'package:noodle_timer/domain/entity/ramen_data_entity.dart';

class RamenDataDTO {
  final List<RamenBrandDTO> brands;

  RamenDataDTO({required this.brands});

  factory RamenDataDTO.fromJson(Map<String, dynamic> json) {
    final ramenDataList = json['ramenData'] as List;
    final brands =
        ramenDataList
            .map((brandJson) => RamenBrandDTO.fromJson(brandJson))
            .toList();

    return RamenDataDTO(brands: brands);
  }

  RamenDataEntity toEntity() {
    return RamenDataEntity(
      brands: brands.map((e) => e.toEntity()).toList(),
    );
  }
}
