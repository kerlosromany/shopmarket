import 'package:admin_app/widgets/subtitle_text.dart';
import 'package:flutter/material.dart';

class DashBoardBtnWidget extends StatelessWidget {
  const DashBoardBtnWidget({super.key, required this.imagePath, required this.title, required this.onPressed});
  final String imagePath, title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(imagePath , height: 65,width: 65,),
            const SizedBox(height: 15,),
            SubtitleTextWidget(label: title , fontSize: 20,),
          ],
        ),
      ),
    );
  }
}