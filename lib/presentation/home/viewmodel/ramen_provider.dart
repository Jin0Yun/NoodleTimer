import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noodle_timer/core/logger/app_logger.dart';
import 'package:noodle_timer/core/logger/console_logger.dart';
import 'package:noodle_timer/data/data_loader.dart';
import 'package:noodle_timer/domain/repository/ramen_repository.dart';
import 'package:noodle_timer/data/repository/ramen_repository_impl.dart';
import 'package:noodle_timer/presentation/home/viewmodel/ramen_state.dart';
import 'package:noodle_timer/presentation/home/viewmodel/ramen_view_model.dart';
import 'package:noodle_timer/presentation/search/viewmodel/search_state.dart';
import 'package:noodle_timer/presentation/search/viewmodel/search_view_model.dart';

final dataLoaderProvider = Provider<IDataLoader>((ref) {
  return DataLoader();
});

final ramenRepositoryProvider = Provider<RamenRepository>((ref) {
  final dataLoader = ref.read(dataLoaderProvider);
  return RamenRepositoryImpl(dataLoader);
});

final loggerProvider = Provider<AppLogger>((ref) => ConsoleLogger());

final ramenViewModelProvider =
    StateNotifierProvider<RamenViewModel, RamenState>((ref) {
      final repo = ref.read(ramenRepositoryProvider);
      final logger = ref.read(loggerProvider);
      return RamenViewModel(repo, logger);
    });

final searchViewModelProvider =
    StateNotifierProvider<SearchViewModel, SearchState>((ref) {
      final repo = ref.read(ramenRepositoryProvider);
      final logger = ref.read(loggerProvider);
      return SearchViewModel(repo, logger);
    });
