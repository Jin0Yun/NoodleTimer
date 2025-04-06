import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/data_loader.dart';
import 'package:noodle_timer/repository/ramen_repository.dart';
import 'package:noodle_timer/repository/ramen_repository_impl.dart';
import 'package:noodle_timer/viewmodel/ramen_state.dart';
import 'package:noodle_timer/viewmodel/ramen_view_model.dart';

final dataLoaderProvider = Provider<IDataLoader>((ref) {
  return DataLoader();
});

final ramenRepositoryProvider = Provider<RamenRepository>((ref) {
  final dataLoader = ref.read(dataLoaderProvider);
  return RamenRepositoryImpl(dataLoader);
});

final ramenViewModelProvider = StateNotifierProvider<RamenViewModel, RamenState>((ref) {
  return RamenViewModel(ref.read(ramenRepositoryProvider));
});