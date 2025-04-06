import 'package:noodle_timer/domain/entity/ramen_brand_entity.dart';

abstract class RamenRepository {
  Future<List<RamenBrandEntity>> loadBrands();
}
