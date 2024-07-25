import 'dart:developer';

import 'package:admin_app/consts/app_methods.dart';
import 'package:admin_app/consts/my_validators.dart';
import 'package:admin_app/screens/inner_screens/orders/loading_screen.dart';
import 'package:admin_app/widgets/app_name_text.dart';
import 'package:admin_app/widgets/subtitle_text.dart';
import 'package:admin_app/widgets/title_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreen extends StatefulWidget {
  static const routName = '/RegisterScreen';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _nameController,
      _emailController,
      _passwordController,
      _confirmPasswordController;
  late final FocusNode _nameFocusNode,
      _emailFocusNode,
      _passwordFocusNode,
      _confirmPasswordFocusNode;
  late final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool _isLoading = false;

  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    _fetchUserNames();

    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    // Focus Nodes
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    // Focus Nodes
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    super.dispose();
  }

  bool _fetchUsersNamesLoader = false;
  List<String> userNames = [];
  _fetchUserNames() async {
    userNames.clear();
    try {
      setState(() {
        _fetchUsersNamesLoader = true;
      });
      // Reference to the Firestore collection
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('manadep');

      // Fetch the documents from the collection
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Iterate through the documents and extract the 'userName' values
      for (var doc in querySnapshot.docs) {
        Map data = doc.data() as Map<String, dynamic>;
        if (doc.exists && data.containsKey('userName')) {
          userNames.add(doc['userName']);
        }
      }
      log(userNames.toString());
    } on FirebaseException catch (e) {
      setState(() {
        _fetchUsersNamesLoader = false;
      });
      log("Error fetching user names: $e");
    } catch (e) {
      setState(() {
        _fetchUsersNamesLoader = false;
      });
      log("Error fetching user names: $e");
    } finally {
      setState(() {
        _fetchUsersNamesLoader = false;
      });
    }
  }

  Future<void> _registerFct() async {
    if (userNames.contains(_nameController.text.trim())) {
      if (!mounted) return;
      await MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "this userName is used before !!",
        fct: () {},
      );
      return;
    }

    final isValid = _formKey.currentState!.validate();
    if (!mounted) return;
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      try {
        setState(() {
          _isLoading = true;
        });

        await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        User? user = auth.currentUser;
        final uid = user!.uid;
        await FirebaseFirestore.instance.collection("manadep").doc(uid).set({
          "userId": uid,
          "userName": _nameController.text.trim(),
          "userEmail": _emailController.text.trim(),
          "userPassword": _passwordController.text.trim(),
        });

        Fluttertoast.showToast(
          msg: "An account has been created",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
        );
      } on FirebaseAuthException catch (error) {
        if (!mounted) return;
        await MyAppMethods.showErrorORWarningDialog(
          context: context,
          subtitle: "An error has been occured ${error.message}",
          fct: () {},
        );
      } catch (error) {
        if (!mounted) return;
        await MyAppMethods.showErrorORWarningDialog(
          context: context,
          subtitle: "An error has been occured $error",
          fct: () {},
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
      isLoading: _fetchUsersNamesLoader,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: LoadingScreen(
          isLoading: _isLoading,
          child: SafeArea(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back))
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      const AppNameTextWidget(
                        fontSize: 30,
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitlesTextWidget(label: "Welcome"),
                            SubtitleTextWidget(label: "Your welcome message")
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Name
                            TextFormField(
                              controller: _nameController,
                              focusNode: _nameFocusNode,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                hintText: "Full name",
                                prefixIcon: Icon(
                                  IconlyLight.profile,
                                ),
                              ),
                              validator: (value) {
                                return MyValidators.displayNamevalidator(value);
                              },
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(_emailFocusNode);
                              },
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            // Email
                            TextFormField(
                              controller: _emailController,
                              focusNode: _emailFocusNode,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: "Email address",
                                prefixIcon: Icon(
                                  IconlyLight.message,
                                ),
                              ),
                              validator: (value) {
                                return MyValidators.emailValidator(value);
                              },
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode);
                              },
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            // Password
                            TextFormField(
                              controller: _passwordController,
                              focusNode: _passwordFocusNode,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: obscureText,
                              decoration: InputDecoration(
                                hintText: "*********",
                                prefixIcon: const Icon(
                                  IconlyLight.lock,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscureText = !obscureText;
                                    });
                                  },
                                  icon: Icon(
                                    obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                return MyValidators.passwordValidator(value);
                              },
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(_confirmPasswordFocusNode);
                              },
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            // Confirm Password
                            TextFormField(
                              controller: _confirmPasswordController,
                              focusNode: _confirmPasswordFocusNode,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: obscureText,
                              decoration: InputDecoration(
                                hintText: "*********",
                                prefixIcon: const Icon(
                                  IconlyLight.lock,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscureText = !obscureText;
                                    });
                                  },
                                  icon: Icon(
                                    obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                return MyValidators.repeatPasswordValidator(
                                    value: value,
                                    password: _passwordController.text);
                              },
                              onFieldSubmitted: (value) {
                                _registerFct();
                              },
                            ),
                            const SizedBox(
                              height: 25.0,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(12),
                                  // backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                ),
                                icon: const Icon(IconlyLight.addUser),
                                label: const Text(
                                  "Sign up",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                onPressed: () async {
                                  _registerFct().then((value) {
                                    setState(() {
                                      _fetchUserNames();
                                    });
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
