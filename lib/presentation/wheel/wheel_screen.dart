import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:ptnzzn_random/constants/app_color.dart';
import 'package:ptnzzn_random/presentation/wheel/wheel_cubit.dart';

class WheelScreen extends StatelessWidget {
  const WheelScreen({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<WheelCubit, WheelState>(
                builder: (context, state) {
                  return FortuneWheel(
                    physics: CircularPanPhysics(
                      duration: Duration(seconds: 1),
                      curve: Curves.decelerate,
                    ),
                    onFling: () {
                      context.read<WheelCubit>().spinWheel();
                    },
                    selected: context.read<WheelCubit>().selectedStream,
                    items: state.items.map((item) {
                      return FortuneItem(
                        child: Text(
                          item,
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: FortuneItemStyle(
                          color: AppColors.lightOrange,
                          borderColor: AppColors.white,
                          borderWidth: 2,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: TextEditingController(),
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter items, separated by new lines',
              ),
              onChanged: (text) {
                final items = text.split('\n').where((item) => item.isNotEmpty).toList();
                context.read<WheelCubit>().updateItems(items);
              },
            ),
            const SizedBox(height: 20),
            BlocBuilder<WheelCubit, WheelState>(
              builder: (context, state) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 650),
                  width: state.isSpinning ? 120 : 200,
                  height: state.isSpinning ? 50 : 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: state.isSpinning ? Colors.grey : Theme.of(context).primaryColor,
                    ),
                    onPressed: state.isSpinning ? null : () => context.read<WheelCubit>().spinWheel(),
                    child: Text(
                      state.isSpinning ? 'Spinning' : 'Spin',
                      style: TextStyle(
                        color: state.isSpinning ? Colors.grey : AppColors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
