import 'package:bloc/bloc.dart';
import 'dart:math';

class YesNoCubit extends Cubit<String> {
  YesNoCubit() : super('');

  void getRandomYesNo() {
    final random = Random(
      'annhannhang'.hashCode,
    );
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final combinedRandom = currentTime + random.nextInt(1000);
    emit(combinedRandom % 2 == 0 ? 'Yes' : 'No');
  }
}