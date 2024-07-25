import 'package:admin_app/models/dashboard_btn_model.dart';
import 'package:admin_app/widgets/dashboard_btn_widget.dart';
import 'package:admin_app/widgets/title_text.dart';
import 'package:flutter/material.dart';

import '../services/assets_manager.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/DashboardScreen';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitlesTextWidget(label: "Dashboard Screen"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.shoppingCart),
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(
          8,
          (index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: DashBoardBtnWidget(
              imagePath: DashboardButtonModel.dashboardBtnList(context)[index].imgPath,
              title: DashboardButtonModel.dashboardBtnList(context)[index].text,
              onPressed: DashboardButtonModel.dashboardBtnList(context)[index].onPressed,
            ),
          ),
        ),
      ),
    );
  }
}
