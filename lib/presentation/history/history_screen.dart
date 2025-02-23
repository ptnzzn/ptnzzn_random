import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ptnzzn_random/logic/storage/history_storage.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Map<String, dynamic>>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _loadHistory();
  }

  Future<List<Map<String, dynamic>>> _loadHistory() async {
    final historyStorage = context.read<HistoryStorage>();
    return await historyStorage.readHistory();
  }

  Future<void> _refreshHistory() async {
    setState(() {
      _historyFuture = _loadHistory();
    });
  }

  String formatDate(String isoDate) {
    final dateTime = DateTime.parse(isoDate);
    return DateFormat.yMMMd().add_jm().format(dateTime);
  }

  String formatGameName(String gameName) {
    switch (gameName) {
      case 'common.spin-wheel':
        return 'common.spin-wheel'.tr();
      case 'common.yes-no':
        return 'common.yes-no'.tr();
      default:
        return gameName;
    }
  }

  String formatResult(String result, String game) {
    if (game == 'common.yes-no') {
      switch (result.toLowerCase()) {
        case 'yes':
          return 'common.yes'.tr();
        case 'no':
          return 'common.no'.tr();
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final historyStorage = context.read<HistoryStorage>();

    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await historyStorage.clearHistory();
              _refreshHistory();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshHistory,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _historyFuture,
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
                    title: Text(formatGameName(entry['game'])),
                    subtitle: Text(formatResult(entry['result'], entry['game'])),
                    trailing: Text(formatDate(entry['date'])),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}