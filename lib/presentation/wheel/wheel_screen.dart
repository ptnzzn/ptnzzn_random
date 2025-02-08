import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:ptnzzn_random/constants/app_color.dart';

class WheelScreen extends StatefulWidget {
  const WheelScreen({super.key});

  @override
  State<WheelScreen> createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> {
  final TextEditingController textController = TextEditingController();
  final StreamController<int> selected = StreamController<int>();
  List<String> _items = ["Yes", "No"];
  final Random _random = Random();
  bool isSpinning = false;

  @override
  void dispose() {
    selected.close();
    textController.dispose();
    super.dispose();
  }

  void updateItems() {
    setState(() {
      final inputItems = textController.text
          .split('\n')
          .where((item) => item.isNotEmpty)
          .toList();
      _items = inputItems.length > 1 ? inputItems : ["Yes", "No"];
    });
  }

  void spinWheel() {
    if (_items.length > 1) {
      setState(() {
        isSpinning = true;
      });
      selected.add(Fortune.randomInt(0, _items.length));
      Future.delayed(Duration(seconds: 5), () {
        setState(() {
          isSpinning = false;
        });
      });
    }
  }

  Color _getRandomLightColor() {
    return Color.fromARGB(
      255,
      200 + _random.nextInt(56), // Ensure the value is between 200 and 255
      200 + _random.nextInt(56),
      200 + _random.nextInt(56),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FortuneWheel(
                physics: CircularPanPhysics(
                  duration: Duration(seconds: 1),
                  curve: Curves.decelerate,
                ),
                onFling: () {
                  spinWheel();
                },
                selected: selected.stream,
                items: _items.map((item) {
                  final color = _getRandomLightColor();
                  return FortuneItem(
                    child: Text(item,
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        )),
                    style: FortuneItemStyle(
                      color: color,
                      borderColor: AppColors.white,
                      borderWidth: 2,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: textController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter items, separated by new lines',
              ),
              onChanged: (text) => updateItems(),
            ),
            const SizedBox(height: 20),
            AnimatedContainer(
              duration: Duration(milliseconds: 650),
              width: isSpinning ? 120 : 200,
              height: isSpinning ? 50 : 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSpinning ? Colors.grey : Theme.of(context).primaryColor,
                ),
                onPressed: isSpinning ? null : spinWheel,
                child: Text(isSpinning ? 'Spinning' : 'Spin',
                    style: TextStyle(
                      color: isSpinning ? Colors.grey : AppColors.white,
                      fontSize: 16,
                    )),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
