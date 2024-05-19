import 'dart:ui';

import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final TextDecoration? textDecoration;
  final String? font;

  const AppText({
    required this.title,
    required this.fontSize,
    this.fontWeight = FontWeight.bold,
    this.color = Colors.white,
    this.textAlign = TextAlign.start,
    this.textDecoration = TextDecoration.none,
    this.font = "Jua",
    super.key});

  @override
  Widget build(BuildContext context) {
    return Text(title,
      style: TextStyle(
        fontWeight: fontWeight,
        fontFamily: font,
        fontSize: fontSize,
        color: color,
        decoration: textDecoration
      ),
      textAlign: textAlign,
    );
  }
}
