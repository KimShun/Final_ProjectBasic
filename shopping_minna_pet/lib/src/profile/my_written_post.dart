import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/component/app_text.dart';
import '../common/cubit/authentication_cubit.dart';
import '../post/post_cubit.dart';

class MyWrittenPostsScreen extends StatefulWidget {
  const MyWrittenPostsScreen({super.key});

  @override
  State<MyWrittenPostsScreen> createState() => _MyWrittenPostsScreenState();
}

class _MyWrittenPostsScreenState extends State<MyWrittenPostsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<PostCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const AppText(
          title: "작성한 게시글",
          fontSize: 23.0,
          textDecoration: TextDecoration.underline,
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                  );
                },
              );
            }

            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    title: "작성한 글이 없어요 ㅠ.ㅠ",
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  Icon(Icons.no_sim_rounded,
                    size: 50.0,
                    color: Colors.redAccent,
                  )
                ],
              ),
            );
          }
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