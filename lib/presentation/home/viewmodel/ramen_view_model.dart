import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/exceptions/ramen_error.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/domain/entity/ramen_brand_entity.dart';
import 'package:noodle_timer/domain/repository/ramen_repository.dart';
import 'package:noodle_timer/presentation/home/viewmodel/ramen_state.dart';

class RamenViewModel extends StateNotifier<RamenState> {
  final RamenRepository _repository;
  final AppLogger _logger;

  RamenViewModel(this._repository, this._logger) : super(RamenState()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final brands = await _repository.loadBrands();

      /// 임시 "나의 라면 기록" 추가
      final updatedBrands = [
        RamenBrandEntity(id: -1, name: "나의 라면 기록", ramens: []),
        ...brands,
      ];

      state = state.copyWith(brands: updatedBrands);
      _logger.d('라면 브랜드 불러오기 완료 (${updatedBrands.length}개)');
    } on RamenError catch (e, st) {
      _logger.e('브랜드 불러오기 실패', e, st);
    }
  }

  void selectBrand(int brandId) {
    try {
      final brand = state.brands.firstWhere((b) => b.id == brandId);
      state = state.copyWith(currentRamenList: brand.ramens);
      _logger.d('브랜드 선택: ${brand.name} (${brand.ramens.length}개)');
    } catch (e, st) {
      _logger.e('브랜드 선택 실패: ID $brandId', e, st);
    }
  }
}