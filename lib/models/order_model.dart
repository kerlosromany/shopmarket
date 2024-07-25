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


