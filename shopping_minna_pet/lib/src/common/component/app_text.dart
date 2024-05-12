import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;

  const AppText({
    required this.title,
    required this.fontSize,
    this.fontWeight = FontWeight.bold,
    this.color = Colors.white,
    this.textAlign = TextAlign.start,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Text(title,
      style: TextStyle(
        fontWeight: fontWeight,
        fontFamily: "Jua",
        fontSize: fontSize,
        color: color,
      ),
      textAlign: textAlign,
    );
  }
}
