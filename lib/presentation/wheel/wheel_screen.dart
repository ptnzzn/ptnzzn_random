import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  void showHistory(
      BuildContext context, TextEditingController textController) async {
    FocusScope.of(context).unfocus(); // Unfocus the text input
    final history = await InputItemsStorage().readInputItems();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Text('history.title'.tr(),
                          style: TextStyle(fontSize: 18)),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await clearHistory();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final item = history[index];
                      final items = item['items'] as List<dynamic>? ?? [];
                      final displayText = items.length > 3
                          ? '${items[0]}, ${items[1]}, ... , ${items.last}'
                          : items.join(', ');

                      return Dismissible(
                        key: Key(item.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) async {
                          history.removeAt(index);
                          await InputItemsStorage().writeInputItems(
                            history.map((item) => item.toString()).toList(),
                          );
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        child: ListTile(
                          title: Text(displayText),
                          onTap: () {
                            final newText = items.join('\n');
                            textController.text = newText;
                            context
                                .read<WheelCubit>()
                                .updateItems(newText.split('\n'));
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> clearHistory() async {
    await InputItemsStorage().clearInputItems();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();
    final FocusNode textFocusNode = FocusNode();

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
                    animateFirst: false,
                    hapticImpact: state.isSpinning
                        ? HapticImpact.medium
                        : HapticImpact.light,
                    onAnimationStart: () {
                      textFocusNode.unfocus();
                    },
                    indicators: <FortuneIndicator>[
                      FortuneIndicator(
                        alignment: Alignment.topCenter,
                        child: TriangleIndicator(
                          color: AppColors.orange,
                          width: 20.0,
                          height: 20.0,
                          elevation: 0,
                        ),
                      ),
                    ],
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
                if (state.isAiMode) {
                  FocusScope.of(context).requestFocus(textFocusNode);
                }
                return TextField(
                  controller: textController,
                  focusNode: textFocusNode,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: state.isAiMode
                        ? 'AI Mode'
                        : 'spin-wheel.input-label'.tr(),
                  ),
                  onChanged: (text) async {
                    final items = text
                        .split('\n')
                        .where((item) => item.isNotEmpty)
                        .toList();
                    context.read<WheelCubit>().updateItems(items);
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
                          context.read<WheelCubit>().toggleAiMode();
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: state.isAiMode
                                ? AppColors.lightBlue
                                : AppColors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/icons/ai.png',
                              width: 32,
                              height: 32,
                            ),
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
                            : () {
                                if (state.isAiMode) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('AI Suggestion'),
                                        content: Text(
                                            'AI suggestion is in development.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  context.read<WheelCubit>().spinWheel();
                                }
                              },
                        child: Text(
                          state.isSpinning
                              ? 'spin-wheel.spinning'.tr()
                              : state.isAiMode
                                  ? 'Ask AI'
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
                        onTap: () => showHistory(context, textController),
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
