part of 'wheel_cubit.dart';

class WheelState {
  final List<String> items;
  final int selectedIndex;
  final bool isSpinning;
  final String? result;
  final bool isAiMode;
  final bool isAiAsking;

  WheelState({
    required this.items,
    required this.selectedIndex,
    required this.isSpinning,
    this.result,
    this.isAiMode = false,
    this.isAiAsking = false,
  });

  factory WheelState.initial() {
    return WheelState(
      items: ["Yes", "No"],
      selectedIndex: 0,
      isSpinning: false,
      result: null,
      isAiMode: false,
      isAiAsking: false,
    );
  }

  WheelState copyWith({
    List<String>? items,
    int? selectedIndex,
    bool? isSpinning,
    String? result,
    bool? isAiMode,
    bool? isAiAsking,
  }) {
    return WheelState(
      items: items ?? this.items,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isSpinning: isSpinning ?? this.isSpinning,
      result: result,
      isAiMode: isAiMode ?? this.isAiMode,
      isAiAsking: isAiAsking ?? this.isAiAsking,
    );
  }
}