import 'package:bloc/bloc.dart';
import 'dart:math';

import 'package:ptnzzn_random/logic/storage/history_storage.dart';

class YesNoCubit extends Cubit<String> {
  final HistoryStorage historyStorage;

  YesNoCubit(this.historyStorage) : super('');

  void getRandomYesNo() async {
    final random = Random(
      'annhannhang'.hashCode,
    );
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final combinedRandom = currentTime + random.nextInt(1000);
    final result = combinedRandom % 2 == 0 ? 'Yes' : 'No';
    emit(result);
    await historyStorage.writeHistory('yes-no', result);
  }
}