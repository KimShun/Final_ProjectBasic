import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_minna_pet/src/common/component/app_text.dart';
import 'package:shopping_minna_pet/src/common/cubit/authentication_cubit.dart';
import 'package:shopping_minna_pet/src/post/cubit/post_cubit.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<PostCubit>().init(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const AppText(
          title: "자유게시판",
          fontSize: 23.0,
          color: Colors.black,
          textDecoration: TextDecoration.underline,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppText(
                  title: "${context.select<AuthenticationCubit, String?>((value) => value.state.user!.name)} 님, 환영합니다.",
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                TextButton(
                  onPressed: () {
                    context.read<PostCubit>().reset();
                    context.push("/writePost");
                  },
                  child: const AppText(title: "[글쓰기] 클릭!", fontSize: 14.0, color: Colors.red,)
                )
              ],
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: BlocBuilder<PostCubit, PostState>(
                builder: (context, state) {
                  if(state.status == PostStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  else if(state.posts!.items!.isNotEmpty) {
                    return ListView.separated(
                      itemCount: state.posts!.items!.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () => context.push("/postdetail", extra: state.posts!.items![index]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column (
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      title: "${state.posts!.items![index].title}",
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                    FutureBuilder<String?>(
                                      future: context.read<AuthenticationCubit>().findUserName(state.posts!.items![index].writerUid!),
                                      builder: (context, snapshot) {
                                        if(snapshot.hasData) {
                                          return AppText(
                                            title: "${state.posts!.items![index].date!.year}-${state.posts!.items![index].date!.month}-${state.posts!.items![index].date!.day} "
                                                "/ ${snapshot.data}",
                                            fontSize: 12.0,
                                            color: Colors.grey,
                                          );
                                        }

                                        return const AppText(
                                          title: "알수없음",
                                          fontSize: 12.0,
                                          color: Colors.grey,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                _showPostImage(images: state.posts!.items![index].images!)
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        title: "작성된 글이 없어요 ㅠ.ㅠ",
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                      Icon(Icons.no_sim_rounded,
                        size: 50.0,
                        color: Colors.redAccent,
                      )
                    ],
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _showPostImage extends StatelessWidget {
  final List<String> images;

  const _showPostImage({
    required this.images,
    super.key});

  @override
  Widget build(BuildContext context) {
    if(images.isEmpty) {
      return Container();
    } else {
      return SizedBox(
        width: 55,
        height: 55,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(images[0], fit: BoxFit.fill)
        ),
      );
    }
  }
}
