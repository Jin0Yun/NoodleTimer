import 'package:noodle_timer/model/ramen_brand.dart';

abstract class RamenRepository {
  Future<List<RamenBrand>> loadBrands();
}
