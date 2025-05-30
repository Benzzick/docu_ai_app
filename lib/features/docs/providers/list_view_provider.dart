import 'package:flutter_riverpod/flutter_riverpod.dart';

final listViewProvider =
    StateNotifierProvider<ListViewNotifier, bool>((ref) => ListViewNotifier());

class ListViewNotifier extends StateNotifier<bool> {
  ListViewNotifier() : super(false);

  void toggleListView() {
    state = !state;
  }
}
