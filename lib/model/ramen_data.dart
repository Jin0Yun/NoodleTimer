import 'package:noodle_timer/model/ramen_brand.dart';

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
}
