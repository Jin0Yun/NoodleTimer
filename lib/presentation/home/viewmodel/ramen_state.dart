import 'package:noodle_timer/core/exceptions/ramen_error.dart';
import 'package:noodle_timer/domain/entity/ramen_brand_entity.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';

class RamenState {
  final List<RamenBrandEntity> brands;
  final List<RamenEntity>? currentRamenList;
  final bool isLoading;
  final RamenError? error;

  RamenState({
    this.brands = const [],
    this.currentRamenList,
    this.isLoading = false,
    this.error,
  });

  RamenState copyWith({
    List<RamenBrandEntity>? brands,
    List<RamenEntity>? currentRamenList,
    bool? isLoading,
    RamenError? error,
  }) {
    return RamenState(
      brands: brands ?? this.brands,
      currentRamenList: currentRamenList ?? this.currentRamenList,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  String? get errorMessage => error?.message;
}

