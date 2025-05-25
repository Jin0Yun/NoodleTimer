import 'dart:convert';
import 'package:noodle_timer/core/exceptions/ramen_exception.dart';
import 'package:noodle_timer/data/utils/data_loader.dart';
import 'package:noodle_timer/data/dto/ramen_data.dart';
import 'package:noodle_timer/domain/entity/ramen_brand_entity.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/domain/repository/ramen_repository.dart';

class RamenRepositoryImpl implements RamenRepository {
  final IDataLoader _dataLoader;
  final String _ramenDataPath = 'assets/json/ramen_data.json';

  RamenRepositoryImpl(this._dataLoader);

  @override
  Future<List<RamenBrandEntity>> loadBrands() async {
    try {
      final jsonString = await _dataLoader.load(_ramenDataPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      return RamenData.fromJson(jsonData).toEntity().brands;
    } catch (e) {
      throw RamenException.fromException(e);
    }
  }

  @override
  Future<List<RamenEntity>> loadAllRamen() async {
    final brands = await loadBrands();
    if (brands.isEmpty) {
      throw RamenException(RamenErrorType.brandNotFound);
    }
    return brands.expand((brand) => brand.ramens).toList();
  }

  @override
  Future<RamenEntity?> findRamenById(int id) async {
    final allRamen = await loadAllRamen();
    try {
      return allRamen.firstWhere((ramen) => ramen.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<RamenEntity>> findRamensByIds(List<int> ids) async {
    final allRamen = await loadAllRamen();
    return allRamen.where((ramen) => ids.contains(ramen.id)).toList();
  }
}