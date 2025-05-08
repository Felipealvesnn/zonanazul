import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;

  const RoundedButton({
    Key? key,
    required this.text,
    // this.press,
    this.color = Colors.yellow,
    this.textColor = Colors.white,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: Get.size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: newElevatedButton(press),
      ),
    );
  }

  //Used:ElevatedButton as FlatButton is deprecated.
  //Here we have to apply customizations to Button by inheriting the styleFrom

  Widget newElevatedButton(press) {
    return ElevatedButton(
      onPressed: press,
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFffcc43),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          textStyle: TextStyle(
              color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
