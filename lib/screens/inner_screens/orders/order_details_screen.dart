import 'dart:io';
import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/screens/inner_screens/orders/order_product_widget.dart';
import 'package:arabic_font/arabic_font.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart' show rootBundle;

class OrderDetailsScreen extends StatefulWidget {
  static const routeName = '/OrderDetailsScreen';
  final OrdersModel order;

  const OrderDetailsScreen({Key? key, required this.order}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Order Details"),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                await _generateAndSharePdf();
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: _buildOrderDetails(),
        ),
      ),
    );
  }

  Widget _buildOrderDetails() {
    return Column(
      children: [
        const Text(
          "معلومات عن العميل",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        const SizedBox(height: 12),
        orderText(txt: "${widget.order.userName} : اسم العميل"),
        const SizedBox(height: 8),
        orderText(txt: "${widget.order.userAddress} : العنوان"),
        const SizedBox(height: 8),
        orderText(txt: "${widget.order.userPhoneNumber} : رقم الموبايل"),
        const SizedBox(height: 8),
        orderText(txt: "${widget.order.totalCost} : تكلفة الطلبية"),
        const SizedBox(height: 8),
        const Text(
          "تفاصيل الطلب:",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return OrderProductWidget(
              prodName: widget.order.productsDetails[index]["productTitle"],
              imgUrl: widget.order.productsDetails[index]["imageUrl"],
              prodPrice: widget.order.productsDetails[index]["price"],
              prodQuantity: widget.order.productsDetails[index]["quantity"].toString(),
            );
          },
          itemCount: widget.order.productsDetails.length,
        ),
      ],
    );
  }

  Text orderText({required String txt}) =>
      Text(txt, style: const ArabicTextStyle(arabicFont: ArabicFont.cairo));

  Future<void> _generateAndSharePdf() async {
    final pdf = pw.Document();
    final arabicFont = await rootBundle.load("fonts/Amiri-Regular.ttf");
    final ttf = pw.Font.ttf(arabicFont);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "معلومات عن العميل",
                  style: pw.TextStyle(
                    font: ttf,
                    fontSize: 30,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Text(
                  "${widget.order.userName} : اسم العميل",
                  style: pw.TextStyle(font: ttf, fontSize: 18),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  "${widget.order.userAddress} : العنوان",
                  style: pw.TextStyle(font: ttf, fontSize: 18),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  "${widget.order.userPhoneNumber} : رقم الموبايل",
                  style: pw.TextStyle(font: ttf, fontSize: 18),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  "${widget.order.totalCost} : تكلفة الطلبية",
                  style: pw.TextStyle(font: ttf, fontSize: 18),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  "تفاصيل الطلب:",
                  style: pw.TextStyle(
                    font: ttf,
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.ListView.builder(
                  itemCount: widget.order.productsDetails.length,
                  itemBuilder: (context, index) {
                    return pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.SizedBox(height: 8),
                        pw.Text(
                          "المنتج: ${widget.order.productsDetails[index]["productTitle"]}",
                          style: pw.TextStyle(font: ttf, fontSize: 18 , color: PdfColors.black),
                        ),
                        pw.Text(
                          "السعر: ${widget.order.productsDetails[index]["price"]}",
                          style: pw.TextStyle(font: ttf, fontSize: 18),
                        ),
                        pw.Text(
                          "الكمية: ${widget.order.productsDetails[index]["quantity"]}",
                          style: pw.TextStyle(font: ttf, fontSize: 18),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/order_details.pdf');
    await file.writeAsBytes(await pdf.save());

    await Share.shareFiles([file.path], text: 'Here are the order details');
  }
}
