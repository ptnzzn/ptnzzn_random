import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class InputItemsStorage {
  static const String _inputItemsKey = 'input_items';

  Future<void> writeInputItems(List<String> items) async {
    if (items.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_inputItemsKey) ?? [];
    final entry = {
      'date': DateTime.now().toIso8601String(),
      'items': items,
    };
    
    final isDuplicate = history.any((e) {
      final decoded = jsonDecode(e);
      return List<String>.from(decoded['items']).toSet().containsAll(items.toSet());
    });

    if (!isDuplicate) {
      history.add(jsonEncode(entry));
      await prefs.setStringList(_inputItemsKey, history);
    }
  }

  Future<List<Map<String, dynamic>>> readInputItems() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_inputItemsKey) ?? [];
    return history.map((e) {
      try {
        final decoded = jsonDecode(e);
        if (decoded['items'] != null && (decoded['items'] as List).isNotEmpty) {
          return Map<String, dynamic>.from(decoded);
        }
      } catch (error) {
        // Handle error if necessary
      }
      return <String, dynamic>{};
    }).where((item) => item.isNotEmpty).toList();
  }

  Future<void> deleteInputItem(String item) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_inputItemsKey) ?? [];
    if (history.isEmpty) return;

    final lastEntry = jsonDecode(history.last) as Map<String, dynamic>;
    final items = (lastEntry['items'] as List).cast<String>();
    items.remove(item);
    
    final updatedEntry = {
      'date': lastEntry['date'],
      'items': items,
    };
    history[history.length - 1] = jsonEncode(updatedEntry);
    await prefs.setStringList(_inputItemsKey, history);
  }

  Future<void> clearInputItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_inputItemsKey);
  }
}
