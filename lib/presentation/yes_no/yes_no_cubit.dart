import 'package:bloc/bloc.dart';
import 'dart:math';

import 'package:ptnzzn_random/logic/storage/random_storage.dart';

class YesNoCubit extends Cubit<String> {
  final RandomStorage randomStorage = RandomStorage();

  YesNoCubit() : super('');

  void getRandomYesNo() async {
    final random = Random(
      'annhannhang'.hashCode,
    );
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final combinedRandom = currentTime + random.nextInt(1000);
    final result = combinedRandom % 2 == 0 ? 'yes' : 'no';
    emit(result);
    await randomStorage.writeRandomHistory('common.yes-no', result);
  }
}