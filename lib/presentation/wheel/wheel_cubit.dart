import 'package:bloc/bloc.dart';
import 'package:ptnzzn_random/logic/storage/input_items_storage.dart';
import 'package:ptnzzn_random/logic/storage/random_storage.dart';
import 'dart:async';
import 'dart:math';
import 'package:rxdart/rxdart.dart';

part 'wheel_state.dart';

class WheelCubit extends Cubit<WheelState> {
  final RandomStorage randomStorage = RandomStorage();
  final InputItemsStorage inputItemsStorage = InputItemsStorage();
  final Random _random = Random();
  final BehaviorSubject<int> _selectedController = BehaviorSubject<int>();

  WheelCubit() : super(WheelState.initial());

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
        await randomStorage.writeRandomHistory('common.spin-wheel', result);
        final existingItems = await inputItemsStorage.readInputItems();
        if (!existingItems.contains(result)) {
          await inputItemsStorage.writeInputItems(state.items);
        }
      });
    }
  }

  void toggleAiMode() {
    emit(state.copyWith(isAiMode: !state.isAiMode));
  }

  @override
  Future<void> close() {
    _selectedController.close();
    return super.close();
  }
}
