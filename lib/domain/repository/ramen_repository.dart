import 'package:noodle_timer/domain/entity/ramen_brand_entity.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';

abstract class RamenRepository {
  Future<List<RamenBrandEntity>> loadBrands();
  Future<List<RamenEntity>> loadAllRamen();
  Future<RamenEntity?> findRamenById(int id);
}
