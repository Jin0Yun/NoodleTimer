import 'package:noodle_timer/domain/entity/ramen_brand_entity.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/domain/repository/ramen_repository.dart';
import 'package:noodle_timer/presentation/common/utils/hangul_utils.dart';

class RamenUseCase {
  final RamenRepository _ramenRepository;

  RamenUseCase(this._ramenRepository);

  Future<List<RamenBrandEntity>> loadBrands() async {
    return await _ramenRepository.loadBrands();
  }

  Future<List<RamenEntity>> loadAllRamen() async {
    return await _ramenRepository.loadAllRamen();
  }

  Future<RamenEntity?> getRamenById(int id) async {
    return await _ramenRepository.findRamenById(id);
  }

  Future<List<RamenEntity>> searchRamen(
    String keyword,
    List<RamenEntity> allRamen,
  ) async {
    if (keyword.trim().isEmpty) {
      return [];
    }

    final lowerKeyword = keyword.toLowerCase();
    return allRamen
        .where(
          (ramen) =>
              ramen.name.toLowerCase().contains(lowerKeyword) ||
              HangulUtils.matchesChoSung(ramen.name, lowerKeyword),
        )
        .toList();
  }
}