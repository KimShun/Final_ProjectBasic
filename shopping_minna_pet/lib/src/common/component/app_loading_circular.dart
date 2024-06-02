import 'package:flutter/material.dart';

class AppLoadingCircular extends StatelessWidget {
  const AppLoadingCircular({super.key});

  @override
  Widget build(BuildContext context) {
    final double phoneWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: phoneWidth >= 400 ? 35.0 : 30.0,
      height: phoneWidth >= 400 ? 35.0 : 30.0,
      child: const CircularProgressIndicator(
        strokeWidth: 2.0,
        color: Colors.yellowAccent,
      ),
    );
  }
}