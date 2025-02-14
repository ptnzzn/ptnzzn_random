import 'package:bloc/bloc.dart';
import 'dart:async';
import 'dart:math';

import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

part 'wheel_state.dart';

class WheelCubit extends Cubit<WheelState> {
  final Random _random = Random();
  final StreamController<int> _selectedController = StreamController<int>();

  WheelCubit() : super(WheelState.initial());

  Stream<int> get selectedStream => _selectedController.stream;

  void updateItems(List<String> newItems) {
    final items = newItems.length > 1 ? newItems : ["Yes", "No"];
    emit(state.copyWith(items: items));
  }

  void spinWheel() {
    if (state.items.length > 1) {
      emit(state.copyWith(isSpinning: true));
      final selectedIndex = _random.nextInt(state.items.length);
      _selectedController.add(selectedIndex);
      Future.delayed(Duration(seconds: 5), () {
        emit(state.copyWith(selectedIndex: selectedIndex, isSpinning: false));
      });
    }
  }

  @override
  Future<void> close() {
    _selectedController.close();
    return super.close();
  }
}
