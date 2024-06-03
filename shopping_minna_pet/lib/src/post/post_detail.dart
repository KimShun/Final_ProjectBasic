import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_minna_pet/src/common/component/app_text.dart';
import 'package:shopping_minna_pet/src/common/cubit/authentication_cubit.dart';

import '../common/model/post_model.dart';
import 'cubit/post_cubit.dart';

class PostDetailScreen extends StatelessWidget {
  final PostModel postModel;

  const PostDetailScreen({
    required this.postModel,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          title: "상세보기",
          fontSize: 23.0,
          color: Colors.black,
        ),
        actions: [
          if(context.select<AuthenticationCubit, String>((value) => value.state.user!.uid!) == postModel.writerUid)
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () {},
                  child: const ListTile(
                    leading: Icon(Icons.edit, size: 25.0),
                    title: Text("수정하기", style: TextStyle(fontSize: 16.0, color: Colors.black)),
                  ),
                ),
                PopupMenuItem(
                  onTap: () async {
                    context.read<PostCubit>().deletePost(postModel.uuid!);
                    await Future.delayed(const Duration(milliseconds: 500));
                    context.go("/"); context.push("/posts");
                  },
                  child: const ListTile(
                    leading: Icon(Icons.delete, size: 25.0),
                    title: Text("삭제하기", style: TextStyle(fontSize: 16.0, color: Colors.black)),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person,
                      size: 40.0,
                    ),
                    const SizedBox(width: 8),
                    FutureBuilder<String?>(
                        future: context.read<AuthenticationCubit>().findUserName(postModel.writerUid!),
                        builder: (context, state) {
                          return Text(state.data!,
                            style: const TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                    ),
                  ],
                ),
                const Icon(Icons.favorite_border,
                  size: 40.0,
                )
              ],
            ),
            const SizedBox(height: 10),
            Text(postModel.title!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )
            ),
            const SizedBox(height: 8),
            Text(postModel.content!,
              style: const TextStyle(
                fontSize: 18
              )
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Created at: ${postModel.date!.year}-${postModel.date!.month}-${postModel.date!.day}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  )
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: postModel.images!.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10.0),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: SizedBox(
                              width: 350,
                              height: 400,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.network(postModel.images![index], fit: BoxFit.fill)
                              ),
                            ),
                          );
                        }
                      );
                    },
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(postModel.images![index], fit: BoxFit.fill,),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}



