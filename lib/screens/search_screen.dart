
import 'package:admin_app/cubits/main_cubit/main_cubit.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';

import '../widgets/product_widget.dart';
import '../widgets/title_text.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/SearchScreen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  List<ProductModel> productListSearch = [];
  @override
  Widget build(BuildContext context) {
    var cubit = MainCubit.get(context);
    

    String? passedCategory =
        ModalRoute.of(context)!.settings.arguments as String?;

    final List<ProductModel> productList = passedCategory == null
        ? cubit.getProducts
        : cubit.findProductsByCat(catName: passedCategory);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: TitlesTextWidget(label: passedCategory ?? "Search"),
        ),
        body: StreamBuilder<List<ProductModel>>(
          stream: cubit.fetchProductsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: TitlesTextWidget(
                  label: snapshot.error.toString(),
                ),
              );
            } else if (snapshot.data == null) {
              return const Center(
                child: TitlesTextWidget(
                  label: "No product has been added",
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    controller: searchTextController,
                    decoration: InputDecoration(
                      hintText: "Search",
                      filled: true,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          // setState(() {
                          searchTextController.clear();
                          FocusScope.of(context).unfocus();
                          // });
                        },
                        child: const Icon(
                          Icons.clear,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      // setState(() {
                      //   productListSearch = cubit.searchQuery(
                      //       searchText: searchTextController.text);
                      // });
                    },
                    onSubmitted: (value) {
                      setState(() {
                        productListSearch = cubit.searchQuery(
                            searchText: searchTextController.text,
                            passedList: productList);
                      });
                    },
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  if (searchTextController.text.isNotEmpty &&
                      productListSearch.isEmpty) ...[
                    const Center(
                        child: TitlesTextWidget(
                      label: "No results found",
                      fontSize: 40,
                    ))
                  ],
                  Expanded(
                    child: DynamicHeightGridView(
                      itemCount: searchTextController.text.isNotEmpty
                          ? productListSearch.length
                          : productList.length,
                      builder: ((context, index) {
                        return ProductWidget(
                          productId: searchTextController.text.isNotEmpty
                              ? productListSearch[index].productId
                              : productList[index].productId,
                        );
                      }),
                      crossAxisCount: 2,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
