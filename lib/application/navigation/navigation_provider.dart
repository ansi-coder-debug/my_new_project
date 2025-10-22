// lib/application/navigation/navigation_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationState {
  final int currentIndex;
  final List<int> history;

  NavigationState({
    required this.currentIndex,
    required this.history,
  });

  NavigationState copyWith({
    int? currentIndex,
    List<int>? history,
  }) {
    return NavigationState(
      currentIndex: currentIndex ?? this.currentIndex,
      history: history ?? this.history,
    );
  }
}

class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier()
      : super(NavigationState(currentIndex: 0, history: [])); // 0 = Dashboard

  void selectPage(int index) {
    // push current page into history before moving
    final newHistory = [...state.history, state.currentIndex];
    state = state.copyWith(currentIndex: index, history: newHistory);
  }

  bool goBack() {
    if (state.history.isEmpty) return false;
    final lastIndex = state.history.last;
    final newHistory = [...state.history]..removeLast();
    state = state.copyWith(currentIndex: lastIndex, history: newHistory);
    return true;
  }
}

final navigationProvider =
    StateNotifierProvider<NavigationNotifier, NavigationState>(
  (ref) => NavigationNotifier(),
);


// Tracks current inventory status (Available, Sold, etc.)
final inventoryStatusProvider = StateProvider<String?>((ref) => 'Available');

//changing app bar name 
final companyNameProvider = StateProvider<String>((ref) => 'Wheelx');