
import 'package:admin_app/consts/app_methods.dart';
import 'package:admin_app/cubits/main_cubit/main_cubit.dart';
import 'package:admin_app/screens/edit_upload_product_form_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'subtitle_text.dart';
import 'title_text.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    super.key,
    required this.productId,
  });

  final String productId;
  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  Future<void> deleteProduct() async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .delete();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This product deleted successfully')));
    } on FirebaseException catch (e) {
      print("Error deleting product: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete product')));
    } catch (e) {
      print("Error deleting product: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete product')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // final productModelProvider = Provider.of<ProductModel>(context);
    var cubit = MainCubit.get(context);
    final getCurrProduct = cubit.findProdByID(widget.productId);
    Size size = MediaQuery.of(context).size;
    return getCurrProduct == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(3.0),
            child: GestureDetector(
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditOrUploadProductScreen(
                              productModel: getCurrProduct,
                            )));
              },
              onLongPress: () {
                MyAppMethods.showErrorORWarningDialog(
                  context: context,
                  subtitle: "Are you sure to delete this item?",
                  fct: () async {
                    await deleteProduct();
                  },
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: FancyShimmerImage(
                      imageUrl: getCurrProduct.productImage,
                      width: double.infinity,
                      height: size.height * 0.22,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TitlesTextWidget(
                    label: getCurrProduct.productTitle,
                    maxLines: 2,
                    fontSize: 18,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: SubtitleTextWidget(
                      label: "${getCurrProduct.productPrice}\$",
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
  }
}
