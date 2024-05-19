import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_minna_pet/src/common/component/app_text.dart';
import 'package:shopping_minna_pet/src/common/cubit/authentication_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppText(title: "로그인 성공!", fontSize: 20.0, color: Colors.black,),
                CircleAvatar(
                  radius: 50.0,
                  backgroundImage: Image.network(state.user!.profile!).image,
                ),
                AppText(title: "${state.user!.name}", fontSize: 18.0, color: Colors.black),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("알림"),
                          content: const Text("정말로 로그아웃을 하시겠습니까?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                context.read<AuthenticationCubit>().logout();
                              },
                              child: const Text("확인"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("취소"),
                            )
                          ],
                        );
                      }
                    );
                  },
                  child: const Text("로그아웃")
                ),
                ElevatedButton(
                  onPressed: () {
                    context.push("/posts");
                  },
                  child: const Text("자유게시판")
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}