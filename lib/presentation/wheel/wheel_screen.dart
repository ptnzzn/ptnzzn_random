import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class WheelScreen extends StatefulWidget {
  const WheelScreen({super.key});

  @override
  State<WheelScreen> createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> {
  final TextEditingController textController = TextEditingController();
  final StreamController<int> selected = StreamController<int>();
  List<String> _items = ["Yes", "No"];

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
      selected.add(Fortune.randomInt(0, _items.length));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Fortune Wheel'),
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
                selected: selected.stream,
                items: _items.map((item) => FortuneItem(child: Text(item))).toList(),
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
            ElevatedButton(
              onPressed: spinWheel,
              child: const Text('Spin'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
