import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfitHistoryScreen extends StatefulWidget {
  final String mandopId;
  const ProfitHistoryScreen({super.key, required this.mandopId});

  @override
  State<ProfitHistoryScreen> createState() => _ProfitHistoryScreenState();
}

class _ProfitHistoryScreenState extends State<ProfitHistoryScreen> {
  Future<List<Map<String, dynamic>>> _fetchProfitHistory() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('profitHistory')
          .where('mandopName', isEqualTo: widget.mandopId)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Error fetching profit history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profit History'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchProfitHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No profit history found.'));
          } else {
            List<Map<String, dynamic>> profitHistory = snapshot.data!;
            Map<int, List<Map<String, dynamic>>> groupedData = {};

            // Group data by year and month
            for (var doc in profitHistory) {
              int year = doc['year'];
              if (!groupedData.containsKey(year)) {
                groupedData[year] = [];
              }
              groupedData[year]!.add(doc);
            }

            // Sort the years in ascending order
            List<int> sortedYears = groupedData.keys.toList()
              ..sort((a, b) => a.compareTo(b));

            return ListView.builder(
              itemCount: sortedYears.length,
              itemBuilder: (context, index) {
                int year = sortedYears[index];
                List<Map<String, dynamic>> yearlyData = groupedData[year]!;

                // Sort the months within each year in ascending order
                yearlyData.sort((a, b) {
                  DateTime monthA = DateFormat('MMMM').parse(a['month']);
                  DateTime monthB = DateFormat('MMMM').parse(b['month']);
                  return monthA.compareTo(monthB); // Ascending order
                });

                return ExpansionTile(
                  title: Text('Year: $year'),
                  children: yearlyData.map((data) {
                    return ListTile(
                      title: Text('Month: ${data['month']}'),
                      subtitle: Text('Profit: ${data['totalProfit']}'),
                    );
                  }).toList(),
                );
              },
            );
          }
        },
      ),
    );
  }
}
