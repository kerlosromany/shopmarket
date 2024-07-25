import 'package:admin_app/widgets/app_name_text.dart';
import 'package:admin_app/widgets/ctg_rounded_widget.dart';
import 'package:admin_app/widgets/title_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';

import 'package:flutter/material.dart';

class CatsScreen extends StatefulWidget {
  static const routeName = '/CatsScreen';
  const CatsScreen({super.key});

  @override
  State<CatsScreen> createState() => _CatsScreenState();
}

class _CatsScreenState extends State<CatsScreen> {
  List<Map<String, String>> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('cats').get();
      final List<Map<String, String>> fetchedCategories = querySnapshot.docs
          .map((doc) => {
                "catImage": doc["catImage"] as String,
                "catName": doc["catName"] as String,
              })
          .toList();
      setState(() {
        categories = fetchedCategories;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const AppNameTextWidget(fontSize: 20),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const TitlesTextWidget(
                label: "Categories",
                fontSize: 22,
              ),
              const SizedBox(height: 18),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : DynamicHeightGridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 30,
                      crossAxisCount: 3,
                      builder:(context, index) {
                        return CategoryRoundedWidget(
                          image: categories[index]["catImage"]!,
                          name: categories[index]["catName"]!,
                        ); 
                      }, itemCount: categories.length, 
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
