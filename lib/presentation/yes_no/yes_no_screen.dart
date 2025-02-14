import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptnzzn_random/presentation/yes_no/yes_no_cubit.dart';

class YesNoScreen extends StatelessWidget {
  const YesNoScreen({super.key});

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
                      TypewriterAnimatedText(
                        'Click to get Yes or No',
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                    repeatForever: false,
                    totalRepeatCount: 1
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  state.isEmpty ? '' : state,
                  style: const TextStyle(
                    fontSize: 20,
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
