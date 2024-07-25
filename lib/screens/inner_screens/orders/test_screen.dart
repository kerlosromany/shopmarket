import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersModel {
  final String orderId;
  final String mandopName;
  final String userId;
  final String userName;
  final String userAddress;
  final String userPhoneNumber;
  final String userImage;
  final Timestamp orderDate;
  final double totalCost;
  final bool orderIsDone;
  final bool mandopMoneyDone;
  final bool adminMoneyDone;
  final List productsDetails;

  OrdersModel({
    required this.orderId,
    required this.mandopName,
    required this.productsDetails,
    required this.userId,
    required this.userName,
    required this.orderDate,
    required this.userAddress,
    required this.userPhoneNumber,
    required this.totalCost,
    required this.orderIsDone,
    required this.userImage,
    required this.mandopMoneyDone,
    required this.adminMoneyDone,
  });

  factory OrdersModel.fromMap(Map<String, dynamic> data) {
    return OrdersModel(
      orderId: data['orderId'],
      mandopName: data['mandopName'],
      userId: data['userId'],
      userName: data['userName'],
      userAddress: data['userAddress'],
      userPhoneNumber: data['userPhoneNumber'],
      userImage: data['userImage'],
      orderDate: data['orderDate'],
      totalCost: data['totalCost'],
      orderIsDone: data['orderIsDone'],
      mandopMoneyDone: data['mandopMoneyDone'],
      adminMoneyDone: data['adminMoneyDone'],
      productsDetails: List<Map<String, dynamic>>.from(data['productsDetails']),
    );
  }
}

class OrdersTestScreen extends StatefulWidget {
  static const routeName = '/OrdersTestScreen';
  const OrdersTestScreen({super.key});

  @override
  State<OrdersTestScreen> createState() => _OrdersTestScreenState();
}

class _OrdersTestScreenState extends State<OrdersTestScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, List<OrdersModel>>> _fetchOrders() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('ordersAdvanced').get();
      List<OrdersModel> orders = querySnapshot.docs
          .map((doc) => OrdersModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      // Group orders by mandopName
      Map<String, List<OrdersModel>> ordersByMandopName = {};
      for (var order in orders) {
        if (!ordersByMandopName.containsKey(order.mandopName)) {
          ordersByMandopName[order.mandopName] = [];
        }
        ordersByMandopName[order.mandopName]!.add(order);
      }

      return ordersByMandopName;
    } catch (e) {
      throw Exception('Error fetching orders: $e');
    }
  }

  void _navigateToOrdersDetailScreen(String mandopName, List<OrdersModel> orders) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrdersDetailsTestScreen(
          mandopName: mandopName,
          orders: orders,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: FutureBuilder<Map<String, List<OrdersModel>>>(
        future: _fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found.'));
          } else {
            Map<String, List<OrdersModel>> ordersByMandopName = snapshot.data!;
            return ListView(
              children: ordersByMandopName.keys.map((mandopName) {
                return ListTile(
                  title: Text(
                    mandopName.isEmpty ? 'Unnamed Mandop' : mandopName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    _navigateToOrdersDetailScreen(
                      mandopName,
                      ordersByMandopName[mandopName]!,
                    );
                  },
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}

class OrdersDetailsTestScreen extends StatelessWidget {
  final String mandopName;
  final List<OrdersModel> orders;

  const OrdersDetailsTestScreen({
    Key? key,
    required this.mandopName,
    required this.orders,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders for $mandopName'),
      ),
      body: ListView.separated(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return ListTile(
            title: Text(order.userName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Address: ${order.userAddress}'),
                Text('Phone: ${order.userPhoneNumber}'),
                Text('Total Cost: \$${order.totalCost.toStringAsFixed(2)}'),
                Text('Order Date: ${order.orderDate.toDate().toString()}'),
              ],
            ),
            trailing: order.orderIsDone
                ? const Icon(Icons.check, color: Colors.green)
                : const Icon(Icons.pending, color: Colors.red),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            color: Colors.black,
            thickness: 2,
          );
        },
      ),
    );
  }
}
