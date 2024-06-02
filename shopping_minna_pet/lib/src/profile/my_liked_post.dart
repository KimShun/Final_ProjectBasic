import 'package:flutter/material.dart';
import 'package:shopping_minna_pet/src/common/component/app_text.dart';

class MyLikedPostsScreen extends StatelessWidget {
  const MyLikedPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const AppText(
          title: "좋아요한 게시글",
          fontSize: 23.0,
          textDecoration: TextDecoration.underline,
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListView.separated(
          itemCount: 10,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        title: "안녕하세요",
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      AppText(
                        title: "2024-06-01"
                            "/ 홍길동",
                        fontSize: 12.0,
                        color: Colors.grey,
                      )
                    ],
                  ),
                  SizedBox(
                    width: 55,
                    height: 55,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset("assets/app/example.png", fit: BoxFit.fill)
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}