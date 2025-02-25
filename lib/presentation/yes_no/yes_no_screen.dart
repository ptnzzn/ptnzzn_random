import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptnzzn_random/presentation/yes_no/yes_no_cubit.dart';

class YesNoScreen extends StatelessWidget {
  const YesNoScreen({super.key});

  String getResultText(String state) {
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

    return text;
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    getResultText(state),
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 650),
                  width: state.isEmpty ? 160 : 100,
                  height: state.isEmpty ? 60 : 50,
                  margin: const EdgeInsets.only(top: 48),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () =>
                        context.read<YesNoCubit>().getRandomYesNo(),
                    child: Text(
                      state.isEmpty
                          ? 'yes-no.get-answer'.tr()
                          : 'yes-no.again'.tr(),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
