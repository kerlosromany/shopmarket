import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_app/models/user_model.dart';
import 'package:flutter/services.dart';

class UpdateUserScreen extends StatefulWidget {
  static const routeName = '/UpdateUserScreen';
  final UserModel user;

  const UpdateUserScreen({super.key, required this.user});

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _imgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.userName;
    _addressController.text = widget.user.userAddress;
    _phoneController.text = widget.user.userPhone;
    _passwordController.text = widget.user.userPassword;
    _emailController.text = widget.user.userEmail;
    _imgController.text = widget.user.userImage;
  }

  Future<void> _updateUser() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.userId)
          .update({
        'userName': _nameController.text,
        'userAddress': _addressController.text,
        'userPhone': _phoneController.text,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Update ${_nameController.text}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("password :  ${_passwordController.text}"),
              Text("Email :  ${_emailController.text}"),
              _imgController.text == ""
                  ? const SizedBox()
                  : Image.network(
                      _imgController.text,
                      width: 0.7 * w,
                      height: 0.7 * w,
                    ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                ),
                maxLines: 4,
                minLines: 1,
              ),
              TextField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 11,
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUser,
                child: const Text('Update User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
