import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RandomStorage {
  static const String _historyKey = 'history';

  Future<void> writeRandomHistory(String game, String result) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_historyKey) ?? [];
    final entry = {
      'date': DateTime.now().toIso8601String(),
      'game': game,
      'result': result,
    };
    history.add(jsonEncode(entry));
    await prefs.setStringList(_historyKey, history);
  }

  Future<List<Map<String, dynamic>>> readRandomHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_historyKey) ?? [];
    return history.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  Future<void> clearRandomHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}