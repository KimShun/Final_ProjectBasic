import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:shopping_minna_pet/src/common/cubit/navigation_cubit.dart';
import 'package:shopping_minna_pet/src/common/cubit/authentication_cubit.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:shopping_minna_pet/src/common/component/app_text.dart';

class EventScreen extends StatefulWidget {

  const EventScreen({Key? key}) : super(key: key);
  @override
  _EventScreenState createState() => _EventScreenState();
}


Widget ImageWithText(String imagePath, String text) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8.0),
    child: Stack(
      children: [
        Image.asset(
          imagePath,
          //width: 200,
          //height: 300,
          fit: BoxFit.fill,
        ),

        Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(220, 160, 0, 0),
              child: ElevatedButton(
                  onPressed: () {

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 3, 199, 90),
                    surfaceTintColor: const Color.fromARGB(255, 3, 199, 90),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),

                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal:30),
                    textStyle: const TextStyle(fontSize: 20),
                    //primary: Colors.green,
                  ),
                  child:  AppText(
                    title: text,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )
              ),
              ),
            ),
          ),
      ],
    ),
  );
}


class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
          child: ListView(
            children: [
              ImageWithText('assets/app/event1.jpg', ' 투표하기'),
              const SizedBox(height: 20,),
              ImageWithText('assets/app/event2.jpg', '투표하기'),
              const SizedBox(height: 20,),
              ImageWithText('assets/app/event1.jpg','신청하기'),
              const SizedBox(height: 20,),
              ImageWithText('assets/app/event2.jpg', '결과확인'),

            ],

          ),
        ),]

      ),






    // 하단 네비게이션 바
      bottomNavigationBar: DotNavigationBar(
        itemPadding: const EdgeInsets.all(14),
        marginR: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        paddingR: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        currentIndex: context.select<NavigationCubit, int>((value) =>
        value.state.selectedNum!),
        onTap: (index) {
          context.read<NavigationCubit>().handleIndexChanged(index, context);
        },
        // dotIndicatorColor: Colors.black,
        items: [
          DotNavigationBarItem(
            icon: const Icon(Icons.pets),
            selectedColor: Colors.brown,
          ),
          DotNavigationBarItem(
            icon: const Icon(Icons.emoji_events),
            selectedColor: Colors.orange,
          ),
          DotNavigationBarItem(
            icon: const Icon(Icons.home),
            selectedColor: Colors.purple,
          ),
          DotNavigationBarItem(
            icon: const Icon(Icons.shopping_cart),
            selectedColor: Colors.black12,
          ),
          DotNavigationBarItem(
            icon: const Icon(Icons.person),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}