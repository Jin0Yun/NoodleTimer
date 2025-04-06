import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/exceptions/ramen_error.dart';
import 'package:noodle_timer/domain/entity/ramen_brand_entity.dart';
import 'package:noodle_timer/domain/repository/ramen_repository.dart';
import 'package:noodle_timer/presentation/home/viewmodel/ramen_state.dart';

class RamenViewModel extends StateNotifier<RamenState> {
  final RamenRepository _repository;

  RamenViewModel(this._repository) : super(RamenState()) {
    loadBrands();
  }

  Future<void> loadBrands() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final brands = await _repository.loadBrands();

      /// 임시 "나의 라면 기록" 추가
      final updatedBrands = [
        RamenBrandEntity(id: -1, name: "나의 라면 기록", ramens: []),
        ...brands,
      ];

      state = state.copyWith(brands: updatedBrands, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error:
            e is RamenError
                ? e : RamenError(RamenErrorType.unknownError, e.toString()),
        isLoading: false,
      );
    }
  }

  void selectBrand(int brandId) {
    try {
      final brand = state.brands.firstWhere((b) => b.id == brandId);
      state = state.copyWith(currentRamenList: brand.ramens, error: null);
    } catch (e) {
      state = state.copyWith(
        error: RamenError(RamenErrorType.brandNotFound, "브랜드 ID: $brandId"),
      );
    }
  }
}