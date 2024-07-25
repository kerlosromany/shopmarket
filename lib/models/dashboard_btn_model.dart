import 'package:admin_app/screens/cats_screen.dart';
import 'package:admin_app/screens/edit_upload_product_form_screen.dart';
import 'package:admin_app/screens/inner_screens/edit_user/edit_users_screen.dart';
import 'package:admin_app/screens/inner_screens/get_manadep_mails_screen.dart';
import 'package:admin_app/screens/inner_screens/orders/orders_screen.dart';
import 'package:admin_app/screens/inner_screens/update_percentage_screen.dart';
import 'package:admin_app/screens/inner_screens/upload_category_screen.dart';
import 'package:admin_app/screens/sign_up_screen.dart';
import 'package:admin_app/services/assets_manager.dart';
import 'package:flutter/material.dart';

class DashboardButtonModel {
  final String text, imgPath;
  final Function onPressed;

  DashboardButtonModel({
    required this.text,
    required this.imgPath,
    required this.onPressed,
  });

  static List<DashboardButtonModel> dashboardBtnList(BuildContext context) => [
    DashboardButtonModel(
      imgPath: AssetsManager.cloud,
      text: "Add a new product",
      onPressed: (){
        Navigator.pushNamed(context, EditOrUploadProductScreen.routeName);
      },
    ),
    DashboardButtonModel(
      imgPath: AssetsManager.shoppingCart,
      text: "Inspect all products",
      onPressed: (){
        Navigator.pushNamed(context, CatsScreen.routeName);
      },
    ),
    DashboardButtonModel(
      imgPath: AssetsManager.order,
      text: "View orders",
      onPressed: (){
        Navigator.pushNamed(context, OrdersScreen.routeName);
      },
    ),
    DashboardButtonModel(
      imgPath: AssetsManager.cloud,
      text: "Add mandop",
      onPressed: (){
        Navigator.pushNamed(context, RegisterScreen.routName);
      },
    ),
    // DashboardButtonModel(
    //   imgPath: AssetsManager.cloud,
    //   text: "Delete mandop",
    //   onPressed: (){
    //     Navigator.pushNamed(context, DeleteManadepScreen.routName);
    //   },
    // ),
    DashboardButtonModel(
      imgPath: AssetsManager.cloud,
      text: "Upload Category",
      onPressed: (){
        Navigator.pushNamed(context, UploadCategoryScreen.routeName);
      },
    ),
    DashboardButtonModel(
      imgPath: AssetsManager.cloud,
      text: "Edit user",
      onPressed: (){
        Navigator.pushNamed(context, EditUsersScreen.routeName);
      },
    ),
    DashboardButtonModel(
      imgPath: AssetsManager.cloud,
      text: "Get manadep mails",
      onPressed: (){
        Navigator.pushNamed(context, GetManadetMailsScreen.routeName);
      },
    ),
    DashboardButtonModel(
      imgPath: AssetsManager.cloud,
      text: "Update percentage",
      onPressed: (){
        Navigator.pushNamed(context, UpdatePercentageScreen.routeName);
      },
    ),
    
  ];
}
