import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:ptnzzn_random/constants/app_color.dart';
import 'package:ptnzzn_random/presentation/wheel/wheel_cubit.dart';
import 'package:ptnzzn_random/logic/storage/input_items_storage.dart';

class WheelScreenListener extends StatelessWidget {
  const WheelScreenListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<WheelCubit, WheelState>(
      listener: (context, state) {
        if (!state.isSpinning && state.result != null) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('spin-wheel.result'.tr()),
                content: Text('spin-wheel.winner'.tr() + state.result!),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('common.agree'.tr()),
                  ),
                ],
              );
            },
          );
        }
      },
      child: WheelScreen(),
    );
  }
}

class WheelScreen extends StatelessWidget {
  const WheelScreen({super.key});

  void showHistory(BuildContext context) async {
    final history = await context.read<WheelCubit>().readInputItems();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: history.map((item) {
            return Container(
              padding: EdgeInsets.all(8.0),
              child: Text(item),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();

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
            BlocBuilder<WheelCubit, WheelState>(
              builder: (context, state) {
                return TextField(
                  controller: textController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'spin-wheel.input-label'.tr(),
                  ),
                  onChanged: (text) async {
                    final items =
                        text.split('\n').where((item) => item.isNotEmpty).toList();
                    context.read<WheelCubit>().updateItems(items);
                    await InputItemsStorage().writeInputItems(items);
                  },
                  enabled: !state.isSpinning,
                );
              },
            ),
            const SizedBox(height: 20),
            BlocBuilder<WheelCubit, WheelState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedOpacity(
                      opacity: state.isSpinning ? 0.0 : 1.0,
                      duration: Duration(milliseconds: 650),
                      child: GestureDetector(
                        onTap: () {
                          
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.star,
                            size: 24,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 650),
                      width: state.isSpinning ? 140 : 200,
                      height: state.isSpinning ? 50 : 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: state.isSpinning
                              ? Colors.grey
                              : Theme.of(context).primaryColor,
                        ),
                        onPressed: state.isSpinning
                            ? null
                            : () => context.read<WheelCubit>().spinWheel(),
                        child: Text(
                          state.isSpinning
                              ? 'spin-wheel.spinning'.tr()
                              : 'spin-wheel.spin'.tr(),
                          style: TextStyle(
                            color: state.isSpinning
                                ? Colors.grey
                                : AppColors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    AnimatedOpacity(
                      opacity: state.isSpinning ? 0.0 : 1.0,
                      duration: Duration(milliseconds: 650),
                      child: GestureDetector(
                        onTap: () => showHistory(context),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.history,
                            size: 24,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    )
                  ],
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
