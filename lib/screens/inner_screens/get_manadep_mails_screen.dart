import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetManadetMailsScreen extends StatefulWidget {
  static const routeName = '/GetManadetMailsScreen';
  const GetManadetMailsScreen({super.key});

  @override
  State<GetManadetMailsScreen> createState() => _GetManadetMailsScreenState();
}

class _GetManadetMailsScreenState extends State<GetManadetMailsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchManadepData() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('manadep').get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<void> _deleteUser(String userId) async {
    try {
      await _firestore.collection('manadep').doc(userId).delete();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );
      setState(() {}); // Refresh the list after deletion
    } on FirebaseException catch (e) {
      print("Error deleting user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete user')),
      );
    } catch (e) {
      print("Error deleting user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete user')),
      );
    }
  }

  void _showDeleteConfirmationDialog(String userId , String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: RichText(text: TextSpan(text: 'Are you sure you want to delete ' ,style: const TextStyle(color: Colors.black),children: [
            TextSpan(text: name  ,style: const TextStyle(fontWeight: FontWeight.w800,color: Colors.black), ) , 
            const TextSpan(text: " ?",style: TextStyle(color: Colors.black)) , 
          ]) ,),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: const Text('Delete' ,style: TextStyle(color: Colors.red) ),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteUser(userId); 
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Manadep Mails'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchManadepData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found.'));
          } else {
            List<Map<String, dynamic>> manadepData = snapshot.data!;
            return ListView.separated(
              itemCount: manadepData.length,
              itemBuilder: (context, index) {
                final manadep = manadepData[index];
                return ListTile(
                  title: Text(
                    manadep['userName'] ?? "",
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(manadep['userEmail'] ?? ""),
                      Text(manadep['userPassword'] ?? ""),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _showDeleteConfirmationDialog(manadep['userId'] ,manadep['userName'] ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Colors.black,
                  thickness: 4,
                );
              },
            );
          }
        },
      ),
    );
  }
}
