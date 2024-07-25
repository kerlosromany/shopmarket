import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class OrderProductWidget extends StatelessWidget {
  final String imgUrl;
  final String prodName;
  final String prodPrice;
  final String prodQuantity;

  const OrderProductWidget({
    Key? key,
    required this.imgUrl,
    required this.prodName,
    required this.prodPrice,
    required this.prodQuantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      padding: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade100,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              _showFullImage(context, imgUrl);
            },
            child: FancyShimmerImage(
              imageUrl: imgUrl,
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.width * 0.3,
              boxFit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductDetailRow("اسم المنتج", prodName),
                  const SizedBox(height: 8),
                  _buildProductDetailRow("الكمية المطلوبة", prodQuantity),
                  const SizedBox(height: 8),
                  _buildProductDetailRow("سعر المنتج", prodPrice),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetailRow(String label, String value) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: InteractiveViewer(
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              child: FancyShimmerImage(imageUrl: imageUrl),
            ),
          ),
        );
      },
    );
  }
}
