import 'package:admin_app/consts/app_constants.dart';
import 'package:admin_app/consts/my_validators.dart';
import 'package:admin_app/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';

class SemiLoginScreen extends StatefulWidget {
  const SemiLoginScreen({super.key});

  @override
  State<SemiLoginScreen> createState() => _SemiLoginScreenState();
}

class _SemiLoginScreenState extends State<SemiLoginScreen> {
  late final TextEditingController _passController;
  late final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text("Enter password to login" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold),),
                const SizedBox(height: 25),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _passController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Enter password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                    validator: (value) {
                      return MyValidators.semiPassvalidator(value);
                    },
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    final isValid = _formKey.currentState!.validate();
                    if (isValid) {
                      if (_passController.text == AppConstants.password) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DashboardScreen(),
                            ));
                      } else {
                        return;
                      }
                    }
                  },
                  child: const Text("Go to app"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
