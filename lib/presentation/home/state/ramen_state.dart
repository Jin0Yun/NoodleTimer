import 'package:noodle_timer/domain/entity/ramen_brand_entity.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';

class RamenState {
  final List<RamenBrandEntity> brands;
  final List<RamenEntity> currentRamenList;
  final RamenEntity? selectedRamen;
  final RamenEntity? temporarySelectedRamen;
  final int selectedBrandIndex;

  const RamenState({
    this.brands = const [],
    this.currentRamenList = const [],
    this.selectedRamen,
    this.temporarySelectedRamen,
    this.selectedBrandIndex = 0,
  });

  RamenState copyWith({
    List<RamenBrandEntity>? brands,
    List<RamenEntity>? currentRamenList,
    RamenEntity? selectedRamen,
    RamenEntity? temporarySelectedRamen,
    int? selectedBrandIndex,
    bool clearSelectedRamen = false,
    bool clearTemporarySelected = false,
  }) {
    return RamenState(
      brands: brands ?? this.brands,
      currentRamenList: currentRamenList ?? this.currentRamenList,
      selectedRamen: clearSelectedRamen ? null : (selectedRamen ?? this.selectedRamen),
      temporarySelectedRamen: clearTemporarySelected ? null : (temporarySelectedRamen ?? this.temporarySelectedRamen),
      selectedBrandIndex: selectedBrandIndex ?? this.selectedBrandIndex,
    );
  }

  bool get hasBrands => brands.isNotEmpty;
  int? get selectedRamenId => temporarySelectedRamen?.id;
}