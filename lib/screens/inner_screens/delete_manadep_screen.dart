// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class DeleteManadepScreen extends StatefulWidget {
//   static const routName = '/DeleteManadepScreen';
//   const DeleteManadepScreen({Key? key}) : super(key: key);

//   @override
//   State<DeleteManadepScreen> createState() => _DeleteManadepScreenState();
// }

// class _DeleteManadepScreenState extends State<DeleteManadepScreen> {
//   List<Map<String, dynamic>> users = [];

//   @override
//   void initState() {
//     super.initState();
//     loadUsers();
//   }

//   Future<void> loadUsers() async {
//     List<Map<String, dynamic>> fetchedUsers = await fetchUsers();
//     setState(() {
//       users = fetchedUsers;
//     });
//   }

//   Future<List<Map<String, dynamic>>> fetchUsers() async {
//     List<Map<String, dynamic>> userList = [];
//     try {
//       QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance.collection('manadep').get();
//       for (var doc in querySnapshot.docs) {
//         userList.add({
//           'id': doc.id,
//           'userName': doc['userName'],
//         });
//       }
//     } catch (e) {
//       print("Error fetching users: $e");
//     }
//     return userList;
//   }

//   Future<void> deleteUser(String userId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('manadep')
//           .doc(userId)
//           .delete();
//       setState(() {
//         users.removeWhere((user) => user['id'] == userId);
//       });
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('User deleted successfully')));
//     } catch (e) {
//       print("Error deleting user: $e");
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text('Failed to delete user')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(title: const Text('Delete Manadep Users')),
//         body: users.isEmpty
//             ? const Center(child: Text("No users to delete"))
//             : ListView.builder(
//                 itemCount: users.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 25.0),
//                     child: Column(
//                       children: [
//                         ListTile(
//                           title: Text(users[index]['userName']),
//                           trailing: IconButton(
//                             icon: const Icon(Icons.delete),
//                             onPressed: () async {
//                               String userId = users[index]['id'];
//                               await deleteUser(userId);
//                             },
//                           ),
//                         ),
//                         const Divider(color: Colors.black , thickness: 2),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//       ),
//     );
//   }
// }
