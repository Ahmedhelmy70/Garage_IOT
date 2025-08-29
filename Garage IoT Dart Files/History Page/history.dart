import 'package:flutter/material.dart';
import '../../main.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> historyData = [];

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    final response =
        await supabase.from('parking').select().eq('username', current_user).order('time', ascending: false);
    setState(() {
      historyData = List<Map<String, dynamic>>.from(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("History"),
        foregroundColor: Colors.white,
      ),
      body: historyData.isEmpty
          ? const Center(
              child: Text("No history found",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            )
          : ListView.builder(
              itemCount: historyData.length,
              itemBuilder: (context, index) {
                final record = historyData[index];
                return Card(
                  color: Colors.grey[900],
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text("User: ${record['username']}",
                        style: const TextStyle(color: Colors.white)),
                    subtitle: Text(
                        "Action: ${record['action']} \nTime: ${record['time']}",
                        style: const TextStyle(color: Colors.white70)),
                  ),
                );
              },
            ),
    );
  }
}