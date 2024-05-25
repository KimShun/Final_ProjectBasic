import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_minna_pet/src/common/component/app_text.dart';
import 'package:shopping_minna_pet/src/post/post_cubit.dart';
import 'package:uuid/uuid.dart';

class WritePostScreen extends StatelessWidget {
  const WritePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          title: "글쓰기",
          fontSize: 23.0,
          color: Colors.black,
          textDecoration: TextDecoration.underline,
        ),
        centerTitle: true,
      ),
      extendBody: true,
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              context.read<PostCubit>().changeTitle(value);
            },
          ),
          TextField(
            onChanged: (value) {
              context.read<PostCubit>().changeContent(value);
            },
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: ElevatedButton(
          onPressed: () {
            context.read<PostCubit>().changeUuid(const Uuid().v4()); // 게시글 고유번호 생성
            context.read<PostCubit>().changeDate(); // 현재 시간으로 등록하기 위함
            context.read<PostCubit>().save(); // 저장
            context.go("/");
            context.push("/posts");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orangeAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: AppText(
                title: "작성하기!!",
                fontSize: MediaQuery.of(context).size.width >= 400 ? 20.0 : 18.0,
              ),
            )
        ),
      ),
    );
  }
}