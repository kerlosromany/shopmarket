import 'dart:developer';
import 'dart:io';

import 'package:admin_app/consts/app_methods.dart';
import 'package:admin_app/consts/my_validators.dart';
import 'package:admin_app/screens/inner_screens/orders/loading_screen.dart';
import 'package:admin_app/widgets/pick_image_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class UploadCategoryScreen extends StatefulWidget {
  static const routeName = '/UploadCategoryScreen';
  const UploadCategoryScreen({super.key});

  @override
  State<UploadCategoryScreen> createState() => _UploadCategoryScreenState();
}

class _UploadCategoryScreenState extends State<UploadCategoryScreen> {
  late final TextEditingController _catController;
  late final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCatsNames();
    _catController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _catController.dispose();
    super.dispose();
  }

  XFile? _pickedImage;
  String imageUrl = "";
  Future<void> localImagePicker() async {
    final ImagePicker picker = ImagePicker();
    await MyAppMethods.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.camera);
        setState(() {});
      },
      galleryFCT: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      removeFCT: () {
        setState(() {
          _pickedImage = null;
          imageUrl = "";
        });
      },
    );
  }

  Future<void> _uploadFct() async {
    if (_catsNames.contains(_catController.text.trim())) {
      if (!mounted) return;
      await MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "this category name is used before !!",
        fct: () {},
      );
      return;
    }
    if (_pickedImage == null) {
      MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "Make sure to pick up an image",
        fct: () {},
      );
      return;
    }

    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      try {
        setState(() {
          _isLoading = true;
        });

        final imgID = const Uuid().v4();
        final ref = FirebaseStorage.instance
            .ref()
            .child("catsImages")
            .child("$imgID.jpg");
        await ref.putFile(File(_pickedImage!.path));
        imageUrl = await ref.getDownloadURL();
        await FirebaseFirestore.instance.collection("cats").doc().set({
          "catName": _catController.text.trim(),
          "catImage": imageUrl,
        });
        Fluttertoast.showToast(
          msg: "the category ${_catController.text} has been uploaded",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
        );
      } on FirebaseException catch (error) {
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
          _pickedImage = null;
          imageUrl = "";
          _catController.clear();
        });
      }
    }
  }

  bool _fetchCatsNamesLoader = false;
  final List<String> _catsNames = [];
  _fetchCatsNames() async {
    _catsNames.clear();
    try {
      setState(() {
        _fetchCatsNamesLoader = true;
      });
      // Reference to the Firestore collection
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('cats');

      // Fetch the documents from the collection
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Iterate through the documents and extract the 'userName' values
      for (var doc in querySnapshot.docs) {
        Map data = doc.data() as Map<String, dynamic>;
        if (doc.exists && data.containsKey('catName')) {
          _catsNames.add(doc['catName']);
        }
      }
      log(_catsNames.toString());
    } on FirebaseException catch (e) {
      setState(() {
        _fetchCatsNamesLoader = false;
      });
      log("Error fetching user names: $e");
    } catch (e) {
      setState(() {
        _fetchCatsNamesLoader = false;
      });
      log("Error fetching user names: $e");
    } finally {
      setState(() {
        _fetchCatsNamesLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: LoadingScreen(
        isLoading: _fetchCatsNamesLoader,
        child: LoadingScreen(
          isLoading: _isLoading,
          child: Scaffold(
            appBar:
                AppBar(title: const Text("Upload Category"), centerTitle: true),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.width * 0.3,
                      width: size.width * 0.3,
                      child: PickImageWidget(
                        pickedImage: _pickedImage,
                        function: () async {
                          await localImagePicker();
                        },
                      ),
                    ),
                    const SizedBox(height: 25),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _catController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: "Enter category name",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.black)),
                        ),
                        validator: (value) {
                          return MyValidators.categoryvalidator(value);
                        },
                      ),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () {
                        _uploadFct().then((value) {
                          setState(() {
                            _fetchCatsNames();
                          });
                        });
                      },
                      child: const Text("Upload Category"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
