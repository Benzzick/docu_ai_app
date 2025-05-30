import 'package:flutter_riverpod/flutter_riverpod.dart';

final sortOptionProvider = StateNotifierProvider<SortOptionNotifier, String>(
    (ref) => SortOptionNotifier());

class SortOptionNotifier extends StateNotifier<String> {
  SortOptionNotifier() : super('Date');

  void toggleSortOption(String option) {
    state = option;
  }
}
