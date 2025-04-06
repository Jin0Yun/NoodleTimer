import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:noodle_timer/data_loader.dart';
import 'package:noodle_timer/entity/ramen_brand_entity.dart';
import 'package:noodle_timer/exceptions/ramen_error.dart';
import 'package:noodle_timer/model/ramen_data.dart';
import 'ramen_repository.dart';

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
}