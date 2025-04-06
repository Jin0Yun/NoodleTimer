import 'package:noodle_timer/data/dto/ramen_brand.dart';
import 'package:noodle_timer/domain/entity/ramen_data_entity.dart';

class RamenData {
  final List<RamenBrand> brands;

  RamenData({required this.brands});

  factory RamenData.fromJson(Map<String, dynamic> json) {
    final ramenDataList = json['ramenData'] as List;
    final brands =
        ramenDataList
            .map((brandJson) => RamenBrand.fromJson(brandJson))
            .toList();

    return RamenData(brands: brands);
  }

  RamenDataEntity toEntity() {
    return RamenDataEntity(
      brands: brands.map((e) => e.toEntity()).toList(),
    );
  }
}
