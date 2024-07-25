import 'package:admin_app/consts/app_methods.dart';
import 'package:admin_app/cubits/order_cubit/order_cubit.dart';
import 'package:admin_app/cubits/order_cubit/order_states.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/screens/inner_screens/orders/orders_widget.dart';
import 'package:admin_app/screens/inner_screens/orders/profit_history_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrdersScreen';
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> fetchMandopNames() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('ordersAdvanced').get();
    Set<String> mandopNames = {};
    for (var doc in querySnapshot.docs) {
      mandopNames.add((doc['mandopName'] == null || doc['mandopName'] == "")
          ? ""
          : doc['mandopName']);
    }
    return mandopNames.toList();
  }

  void _navigateToOrdersDetailScreen(String mandopName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrdersDetailsTestScreen(
          mandopName: mandopName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersCubit, OrdersStates>(
      listener: (context, state) {
        if (state is DeleteMandopOrderFailureState) {
          MyAppMethods.showErrorORWarningDialog(
            context: context,
            subtitle:
                "لا يمكنك مسح هذه الطلبية حتى يقوم المندوب بالتأكيد على انه حصل على ارباحه",
            fct: () {},
            isError: true,
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Orders'),
            ),
            body: FutureBuilder<List<String>>(
              future: fetchMandopNames(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No orders found.'));
                } else {
                  List<String> mandopNames = snapshot.data!;
                  return ListView(
                    children: mandopNames.map((mandopName) {
                      return ListTile(
                        title: Text(
                          mandopName.isEmpty
                              ? 'Orders'
                              : "Orders by $mandopName",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          _navigateToOrdersDetailScreen(mandopName);
                        },
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class OrdersDetailsTestScreen extends StatelessWidget {
  final String mandopName;

  const OrdersDetailsTestScreen({
    Key? key,
    required this.mandopName,
  }) : super(key: key);

  Stream<List<OrdersModel>> fetchOrdersForMandopStream() {
    return FirebaseFirestore.instance
        .collection('ordersAdvanced')
        .orderBy('orderDate', descending: true)
        .where('mandopName', isEqualTo: mandopName.isEmpty ? '' : mandopName)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.reversed
          .map((doc) => OrdersModel.fromMap(doc.data()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: mandopName.isEmpty
            ? const Text('Orders')
            : FittedBox(child: Text('Orders for $mandopName')),
      ),
      body: StreamBuilder<List<OrdersModel>>(
        stream: fetchOrdersForMandopStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found.'));
          } else {
            List<OrdersModel> orders = snapshot.data!;
            return Column(
              children: [
                mandopName == ""
                    ? const SizedBox()
                    : InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ProfitHistoryScreen(
                                mandopId: mandopName,
                              );
                            },
                          ));
                        },
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                          child: const ListTile(
                            title: Text("ارباح المندوب خلال الشهور الماضية"),
                            trailing: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                Expanded(
                  child: ListView.separated(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return OrderWidget(ordersModel: order);
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: Colors.black,
                        thickness: 2,
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
