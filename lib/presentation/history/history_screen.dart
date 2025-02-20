import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptnzzn_random/logic/storage/history_storage.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyStorage = context.read<HistoryStorage>();

    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: historyStorage.readHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading history'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No history available'));
          } else {
            final history = snapshot.data!;
            return ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final entry = history[index];
                return ListTile(
                  title: Text(entry['game']),
                  subtitle: Text(entry['result']),
                  trailing: Text(entry['date']),
                );
              },
            );
          }
        },
      ),
    );
  }
}