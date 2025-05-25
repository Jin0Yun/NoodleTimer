import 'package:noodle_timer/domain/entity/ramen_brand_entity.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/presentation/common/state/base_state.dart';

class RamenState implements BaseState {
  final List<RamenBrandEntity> brands;
  final List<RamenEntity> currentRamenList;
  final RamenEntity? selectedRamen;
  final RamenEntity? temporarySelectedRamen;
  final int selectedBrandIndex;
  final List<RamenEntity> allRamen;
  final String searchKeyword;
  final List<RamenEntity> searchResults;
  final bool _isLoading;
  final String? _error;

  const RamenState({
    this.brands = const [],
    this.currentRamenList = const [],
    this.selectedRamen,
    this.temporarySelectedRamen,
    this.selectedBrandIndex = 0,
    this.allRamen = const [],
    this.searchKeyword = '',
    this.searchResults = const [],
    bool isLoading = false,
    String? error,
  }) : _isLoading = isLoading,
        _error = error;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get error => _error;

  bool get hasSearchResults => searchResults.isNotEmpty;
  bool get isSearching => searchKeyword.isNotEmpty;

  RamenState copyWith({
    List<RamenBrandEntity>? brands,
    List<RamenEntity>? currentRamenList,
    RamenEntity? selectedRamen,
    RamenEntity? temporarySelectedRamen,
    int? selectedBrandIndex,
    List<RamenEntity>? allRamen,
    String? searchKeyword,
    List<RamenEntity>? searchResults,
    bool? isLoading,
    String? error,
    bool clearSelectedRamen = false,
    bool clearTemporarySelected = false,
  }) {
    return RamenState(
      brands: brands ?? this.brands,
      currentRamenList: currentRamenList ?? this.currentRamenList,
      selectedRamen: clearSelectedRamen ? null : (selectedRamen ?? this.selectedRamen),
      temporarySelectedRamen: clearTemporarySelected ? null : (temporarySelectedRamen ?? this.temporarySelectedRamen),
      selectedBrandIndex: selectedBrandIndex ?? this.selectedBrandIndex,
      allRamen: allRamen ?? this.allRamen,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? _isLoading,
      error: error,
    );
  }
}