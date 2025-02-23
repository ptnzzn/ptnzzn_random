import 'package:bloc/bloc.dart';
import 'package:ptnzzn_random/logic/storage/history_storage.dart';
import 'dart:async';
import 'dart:math';
import 'package:rxdart/rxdart.dart';

part 'wheel_state.dart';

class WheelCubit extends Cubit<WheelState> {
  final HistoryStorage historyStorage;
  final Random _random = Random();
  final BehaviorSubject<int> _selectedController = BehaviorSubject<int>();

  WheelCubit(this.historyStorage) : super(WheelState.initial());

  Stream<int> get selectedStream => _selectedController.stream;

  void updateItems(List<String> newItems) {
    final items = newItems.length > 1 ? newItems : ["Yes", "No"];
    emit(state.copyWith(items: items));
  }

  void spinWheel() async {
    if (state.items.length > 1) {
      emit(state.copyWith(isSpinning: true));
      final selectedIndex = _random.nextInt(state.items.length);
      _selectedController.add(selectedIndex);
      Future.delayed(Duration(seconds: 5), () async {
        final result = state.items[selectedIndex];
        emit(state.copyWith(
          selectedIndex: selectedIndex, 
          isSpinning: false,
          result: result,
        ));
        await historyStorage.writeHistory('common.spin-wheel', result);
      });
    }
  }

  @override
  Future<void> close() {
    _selectedController.close();
    return super.close();
  }
}
