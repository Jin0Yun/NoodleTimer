import 'dart:convert';
import 'package:noodle_timer/core/exceptions/ramen_exception.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/data/utils/data_loader.dart';
import 'package:noodle_timer/data/dto/ramen_data.dart';
import 'package:noodle_timer/domain/entity/ramen_brand_entity.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/domain/repository/ramen_repository.dart';

class RamenRepositoryImpl implements RamenRepository {
  final IDataLoader _dataLoader;
  final AppLogger _logger;
  final String _ramenDataPath = 'assets/json/ramen_data.json';

  List<RamenBrandEntity>? _cachedBrands;

  RamenRepositoryImpl({
    required IDataLoader dataLoader,
    required AppLogger logger,
  }) : _dataLoader = dataLoader,
       _logger = logger;

  @override
  Future<List<RamenBrandEntity>> loadBrands() async {
    if (_cachedBrands != null) {
      return _cachedBrands!;
    }

    try {
      final jsonString = await _dataLoader.load(_ramenDataPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      _cachedBrands = RamenData.fromJson(jsonData).toEntity().brands;
      _logger.i('라면 브랜드 로딩 성공: ${_cachedBrands!.length}개 브랜드');
      return _cachedBrands!;
    } catch (e) {
      _logger.e('라면 브랜드 로딩 실패', e);
      throw RamenException.fromException(e);
    }
  }

  @override
  Future<List<RamenEntity>> loadAllRamen() async {
    try {
      final brands = await loadBrands();
      if (brands.isEmpty) {
        _logger.w('브랜드를 찾을 수 없음');
        throw RamenException(RamenErrorType.brandNotFound);
      }
      final allRamen = brands.expand((brand) => brand.ramens).toList();
      _logger.i('전체 라면 로딩 성공: ${allRamen.length}개 라면');
      return allRamen;
    } catch (e) {
      _logger.e('전체 라면 로딩 실패', e);
      if (e is RamenException) {
        rethrow;
      } else {
        throw RamenException.fromException(e);
      }
    }
  }

  @override
  Future<RamenEntity?> findRamenById(int id) async {
    try {
      final allRamen = await loadAllRamen();
      final ramen = allRamen.firstWhere((ramen) => ramen.id == id);
      _logger.i('라면 조회 성공: ${ramen.name} (ID: $id)');
      return ramen;
    } catch (e) {
      _logger.w('라면 조회 실패: ID $id');
      return null;
    }
  }

  @override
  Future<List<RamenEntity>> findRamensByIds(List<int> ids) async {
    try {
      final allRamen = await loadAllRamen();
      final foundRamen =
          allRamen.where((ramen) => ids.contains(ramen.id)).toList();
      _logger.i('라면 목록 조회 성공: ${foundRamen.length}개 라면');
      return foundRamen;
    } catch (e) {
      _logger.e('라면 목록 조회 실패', e);
      throw RamenException.fromException(e);
    }
  }
}