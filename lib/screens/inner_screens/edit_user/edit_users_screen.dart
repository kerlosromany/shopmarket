import 'dart:developer';

import 'package:admin_app/models/user_model.dart';
import 'package:admin_app/screens/inner_screens/edit_user/update_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class EditUsersScreen extends StatefulWidget {
  static const routeName = '/EditUsersScreen';
  const EditUsersScreen({super.key});

  @override
  State<EditUsersScreen> createState() => _EditUsersScreenState();
}

class _EditUsersScreenState extends State<EditUsersScreen> {
  final TextEditingController _phoneController = TextEditingController();
  UserModel? _user;

  Future<void> _searchUserByPhone() async {
    String phone = _phoneController.text;
    if (phone.isEmpty) return;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userPhone', isEqualTo: phone)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _user = UserModel.fromMap(
              querySnapshot.docs.first.data() as Map<String, dynamic>);
        });
      } else {
        setState(() {
          _user = null;
        });
      }
    } catch (e) {
      log("Error fetching user data: $e");
      setState(() {
        _user = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 11,
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Enter Phone Number',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchUserByPhone,
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            _user == null
                ? const Text('No user found' , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w700),)
                : InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UpdateUserScreen(user: _user!),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text('Name: ${_user!.userName}'),
                      subtitle: Text('Phone: ${_user!.userPhone}'),
                      leading: const Icon(Icons.edit),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
