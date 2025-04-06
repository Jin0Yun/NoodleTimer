import 'package:noodle_timer/entity/ramen_brand_entity.dart';

abstract class RamenRepository {
  Future<List<RamenBrandEntity>> loadBrands();
}
