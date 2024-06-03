import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:shopping_minna_pet/src/common/cubit/navigation_cubit.dart';
import 'package:shopping_minna_pet/src/common/cubit/authentication_cubit.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:shopping_minna_pet/src/common/component/app_text.dart';

class BasketScreen extends StatefulWidget {

  const BasketScreen({Key? key}) : super(key: key);
  @override
  _BasketScreenState createState() => _BasketScreenState();
}

class  _BasketScreenState extends State<BasketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context); //뒤로가기
            },
            color: Colors.amber,
            iconSize: 35,
            icon: Icon(Icons.arrow_back)),
        title: Image.asset(
          "assets/app/logo2.png",
          width: 150,
          height: 130,
        ),
        centerTitle: true,
        actions: const [
          Icon(
            Icons.notifications,
            color: Colors.brown,
            size: 40,
          ),

          SizedBox(width: 10.0),
        ],
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 280.0,
              child: ElevatedButton(
                  onPressed: () {
                    // 로그인 버튼 클릭 시 동작을 여기에 추가합니다.
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 3, 199, 90),
                    surfaceTintColor: const Color.fromARGB(255, 3, 199, 90),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 30),
                    textStyle: const TextStyle(fontSize: 20),
                    //primary: Colors.green,
                  ),
                  child: const AppText(
                    title: "주문하기",
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}