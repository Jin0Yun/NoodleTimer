import 'package:noodle_timer/domain/entity/ramen_brand_entity.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';

class RamenState {
  final List<RamenBrandEntity> brands;
  final List<RamenEntity>? currentRamenList;

  RamenState({
    this.brands = const [],
    this.currentRamenList
  });

  RamenState copyWith({
    List<RamenBrandEntity>? brands,
    List<RamenEntity>? currentRamenList
  }) {
    return RamenState(
      brands: brands ?? this.brands,
      currentRamenList: currentRamenList ?? this.currentRamenList
    );
  }

  bool get hasBrands => brands.isNotEmpty;
}

