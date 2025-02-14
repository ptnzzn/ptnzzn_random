part of 'wheel_cubit.dart';

class WheelState {
  final List<String> items;
  final int selectedIndex;
  final bool isSpinning;

  WheelState({
    required this.items,
    required this.selectedIndex,
    required this.isSpinning,
  });

  factory WheelState.initial() {
    return WheelState(
      items: ["Yes", "No"],
      selectedIndex: 0,
      isSpinning: false,
    );
  }

  WheelState copyWith({
    List<String>? items,
    int? selectedIndex,
    bool? isSpinning,
  }) {
    return WheelState(
      items: items ?? this.items,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isSpinning: isSpinning ?? this.isSpinning,
    );
  }
}