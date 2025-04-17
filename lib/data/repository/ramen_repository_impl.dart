import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:noodle_timer/core/exceptions/ramen_error.dart';
import 'package:noodle_timer/data/service/data_loader.dart';
import 'package:noodle_timer/data/dto/ramen_data.dart';
import 'package:noodle_timer/domain/entity/ramen_brand_entity.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import '../../domain/repository/ramen_repository.dart';

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
    } on FlutterError catch (e) {
      throw RamenError(RamenErrorType.assetNotFound, e.toString());
    } on FormatException catch (e) {
      throw RamenError(RamenErrorType.parsingError, e.toString());
    } catch (e) {
      throw RamenError(RamenErrorType.unknownError, e.toString());
    }
  }

  @override
  Future<List<RamenEntity>> loadAllRamen() async {
    final brands = await loadBrands();
    if (brands.isEmpty) {
      throw RamenError(RamenErrorType.brandNotFound);
    }
    return brands.expand((brand) => brand.ramens).toList();
  }

  @override
  Future<RamenEntity> findRamenById(int id) async {
    final allRamen = await loadAllRamen();

    try {
      return allRamen.firstWhere((ramen) => ramen.id == id);
    } on StateError catch (_) {
      throw RamenError(
        RamenErrorType.ramenNotFound,
        '해당 ID의 라면을 찾을 수 없습니다: id=$id',
      );
    }
  }
}
