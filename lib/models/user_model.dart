import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId, userName, userEmail, userImage, userAddress, userPhone, mandopName , userPassword;
  final Timestamp createdAt;
  final List<dynamic> userCartList;
  final List<dynamic> userWishList;
  final int numberofItems;
  final double totalPrice;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userImage,
    required this.createdAt,
    required this.userWishList,
    required this.userCartList,
    required this.userAddress,
    required this.userPhone,
    required this.numberofItems,
    required this.totalPrice,
    required this.mandopName,
    required this.userPassword,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      userId: data['userId'],
      userName: data['userName'],
      userEmail: data['userEmail'],
      userImage: data['userImage'],
      createdAt: data['createdAt'],
      userWishList: List<dynamic>.from(data['userWishList']),
      userCartList: List<dynamic>.from(data['userCartList']),
      userAddress: data['userAddress'],
      userPhone: data['userPhone'],
      numberofItems: data['numberofItems'],
      totalPrice: data['totalPrice'],
      mandopName: data['mandopName'],
      userPassword: data['userPassword'],
    );
  }
}
