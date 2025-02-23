import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptnzzn_random/presentation/yes_no/yes_no_cubit.dart';

class YesNoScreen extends StatelessWidget {
  const YesNoScreen({super.key});

  TypewriterAnimatedText getAnimatedText(String state) {
    String text;
    if (state.isEmpty) {
      text = 'yes-no.label'.tr();
    } else if (state == 'yes') {
      text = 'yes-no.yes'.tr() + 'common.yes'.tr();
    } else if (state == 'no') {
      text = 'yes-no.no'.tr() + 'common.no'.tr() + 'yes-no.no-end'.tr();
    } else {
      text = state;
    }

    return TypewriterAnimatedText(
      text,
      speed: const Duration(milliseconds: 100),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: 32,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: BlocBuilder<YesNoCubit, String>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      getAnimatedText(state),
                    ],
                    repeatForever: false,
                    totalRepeatCount: 1,
                    onFinished: () {
                      // Trigger a rebuild to update the text
                      context.read<YesNoCubit>().emit(state);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<YesNoCubit>().getRandomYesNo(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
