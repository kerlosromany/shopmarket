import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String productId,
      productTitle,
      productPrice,
      productCategory,
      productDescription,
      productImage,
      productQuantity;
  final Timestamp createdAt;
  final bool productStatus;

  ProductModel({
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.productCategory,
    required this.productDescription,
    required this.productImage,
    required this.productQuantity,
    required this.createdAt,
    required this.productStatus,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      productId: data['productId'], //doc.get("productId"),
      productTitle: data['productTitle'],
      productPrice: data['productPrice'],
      productCategory: data['productCategory'],
      productDescription: data['productDescription'],
      productImage: data['productImage'],
      productQuantity: data['productQuantity'].toString(),
      createdAt: data['createdAt'],
      productStatus: data['productStatus'],
    );
  }
}
