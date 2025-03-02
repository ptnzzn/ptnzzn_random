import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
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

  Future<String> getAiResult(String inputPrompt) async {
    emit(state.copyWith(isAiAsking: true));
    final model = GenerativeModel(
      model: 'gemini-2.0-pro-exp-02-05', 
      apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
    );
    final prompt = 'Type a list of items with $inputPrompt each item is separated by a new line. Only response item and items have no number on front of each item.';
    final content = [Content.text(prompt)];
    try {
      final response = await model.generateContent(content);
      emit(state.copyWith(isAiAsking: false, isAiMode: false));
      return response.text ?? '';
    } catch (e) {
      emit(state.copyWith(isAiAsking: false));
      rethrow;
    }
  }

  @override
  Future<void> close() {
    _selectedController.close();
    return super.close();
  }
}
