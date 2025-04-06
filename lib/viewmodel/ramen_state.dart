import 'package:noodle_timer/exceptions/ramen_error.dart';
import 'package:noodle_timer/model/ramen.dart';
import 'package:noodle_timer/model/ramen_brand.dart';

class RamenState {
  final List<RamenBrand> brands;
  final List<Ramen>? currentRamenList;
  final bool isLoading;
  final RamenError? error;

  RamenState({
    this.brands = const [],
    this.currentRamenList,
    this.isLoading = false,
    this.error,
  });

  RamenState copyWith({
    List<RamenBrand>? brands,
    List<Ramen>? currentRamenList,
    bool? isLoading,
    RamenError? error,
  }) {
    return RamenState(
      brands: brands ?? this.brands,
      currentRamenList: currentRamenList ?? this.currentRamenList,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  String? get errorMessage => error?.message;
}
