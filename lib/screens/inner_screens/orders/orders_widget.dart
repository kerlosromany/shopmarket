import 'package:admin_app/cubits/order_cubit/order_cubit.dart';
import 'package:admin_app/cubits/order_cubit/order_states.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/screens/inner_screens/orders/order_details_screen.dart';
import 'package:admin_app/services/my_app_method.dart';
import 'package:admin_app/widgets/subtitle_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class OrderWidget extends StatefulWidget {
  final OrdersModel ordersModel;
  const OrderWidget({super.key, required this.ordersModel});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd – hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    OrdersCubit ordersCubit = OrdersCubit.get(context);
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OrderDetailsScreen(order: widget.ordersModel),
            ));
      },
      child: BlocBuilder<OrdersCubit, OrdersStates>(
        builder: (context, state) {
          //log("message");
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
              color: widget.ordersModel.orderIsDone ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                widget.ordersModel.mandopName == ""
                    ? const SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.ordersModel.mandopName),
                          orderText(txt: " : المندوب"),
                        ],
                      ),
                widget.ordersModel.mandopName == ""
                    ? const SizedBox()
                    : const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.ordersModel.userName),
                    orderText(txt: " : العميل"),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatTimestamp(widget.ordersModel.orderDate)),
                    orderText(txt: " : تاريخ الطلبية"),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                          onPressed: () async {
                            await MyAppMethods.showErrorORWarningDialog(
                              context: context,
                              subtitle: widget.ordersModel.orderIsDone == false
                                  ? "هل انت متأكد ان هذه الطلبية تم ارسالها ؟"
                                  : "هل انت متأكد من ان هذه الطلبية لم يتم ارسالها",
                              fct: () => widget.ordersModel.orderIsDone == false
                                  ? ordersCubit.updateOrderStatus(
                                      orderId: widget.ordersModel.orderId,
                                      orderIsDoneValue: true)
                                  : ordersCubit.updateOrderStatus(
                                      orderId: widget.ordersModel.orderId,
                                      orderIsDoneValue: false),
                              isError: false,
                            );
                          },
                          child: Icon(widget.ordersModel.orderIsDone
                              ? Icons.done
                              : Icons.close)),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(widget.ordersModel.userName),
                                              orderText(txt: " : العميل"),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 16.0,
                                        ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(widget
                                                  .ordersModel.userAddress),
                                              orderText(txt: " : العنوان"),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 16.0,
                                        ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(widget
                                                  .ordersModel.userPhoneNumber),
                                              orderText(txt: " : رقم الموبايل"),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 16.0,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const SubtitleTextWidget(
                                              label: "Cancel",
                                              color: Colors.green),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: const FittedBox(
                            child: Text(
                          "معلومات عن العميل",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        )),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                          onPressed: () async {
                            await MyAppMethods.showErrorORWarningDialog(
                              context: context,
                              subtitle: "Are you sure to delete?",
                              fct: () => widget.ordersModel.mandopName == ""
                                  ? ordersCubit.deleteOrder(
                                      orderId: widget.ordersModel.orderId)
                                  : ordersCubit.deleteMandopOrder(
                                      orderId: widget.ordersModel.orderId),
                              isError: false,
                            );
                          },
                          child: const Icon(Icons.delete)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Text orderText({required String txt}) => Text(
        txt,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      );
}
