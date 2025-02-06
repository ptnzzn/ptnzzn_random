import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptnzzn_random/logic/cubit/yes_no_cubit.dart';

class YesNoScreen extends StatelessWidget {
  const YesNoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Yes or No'),
      ),
      body: Center(
        child: BlocBuilder<YesNoCubit, String>(
          builder: (context, state) {
            return Text(
              state,
              style: const TextStyle(fontSize: 24),
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
