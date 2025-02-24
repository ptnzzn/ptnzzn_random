import 'package:shared_preferences/shared_preferences.dart';

class InputItemsStorage {
  static const String _inputItemsKey = 'input_items';

  Future<void> writeInputItems(List<String> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_inputItemsKey, items);
  }

  Future<List<String>> readInputItems() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_inputItemsKey) ?? [];
  }

  Future<void> deleteInputItem(String item) async {
    final prefs = await SharedPreferences.getInstance();
    final inputItems = prefs.getStringList(_inputItemsKey) ?? [];
    inputItems.remove(item);
    await prefs.setStringList(_inputItemsKey, inputItems);
  }

  Future<void> clearInputItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_inputItemsKey);
  }
}
