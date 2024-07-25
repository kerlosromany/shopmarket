import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdatePercentageScreen extends StatefulWidget {
  static const routeName = '/UpdatePercentageScreen';
  const UpdatePercentageScreen({super.key});

  @override
  State<UpdatePercentageScreen> createState() => _UpdatePercentageScreenState();
}

class _UpdatePercentageScreenState extends State<UpdatePercentageScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _documentId = "ICxjkM1jqQyr66x9ACT9";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCurrentPercentage();
  }

  Future<void> _fetchCurrentPercentage() async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('pecentage').doc(_documentId).get();
      if (docSnapshot.exists) {
        setState(() {
          _controller.text = docSnapshot['pecentage'].toString();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        if(!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Document does not exist')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch percentage: $e')),
      );
    }
  }

  Future<void> _updatePercentage(double percentage) async {
    try {
      await _firestore.collection('pecentage').doc(_documentId).update({
        'pecentage': percentage,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Percentage updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update percentage: $e')),
      );
    }
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final double percentage = double.parse(_controller.text);
      _updatePercentage(percentage);
    }
  }

  String? _validatePercentage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }
    final double? percentage = double.tryParse(value);
    if (percentage == null) {
      return 'Please enter a valid number';
    }
    if (percentage < 0.001 || percentage > 100) {
      return 'Percentage must be between 0.001 and 100';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Percentage'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Enter Percentage',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: _validatePercentage,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _onSubmit,
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
