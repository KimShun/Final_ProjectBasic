import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_minna_pet/src/common/component/app_text.dart';
import 'package:shopping_minna_pet/src/post/post_cubit.dart';
import 'package:uuid/uuid.dart';

import '../common/component/app_loading_circular.dart';
import '../common/cubit/upload_cubit.dart';

class WritePostScreen extends StatelessWidget {
  const WritePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double phoneWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const AppText(
          title: "글쓰기",
          fontSize: 23.0,
          color: Colors.black,
          textDecoration: TextDecoration.underline,
        ),
        centerTitle: true,
      ),
      extendBody: true,
      body: MultiBlocListener(
        listeners: [
          BlocListener<PostCubit, PostState>(
              listenWhen: (previous, current) => previous.status != current.status,
              listener: (context, state) async {
                switch (state.status) {
                  case PostStatus.init:
                    break;
                  case PostStatus.loading:
                    break;
                  case PostStatus.uploading:
                    context.read<UploadCubit>().uploadImages(state.imageFiles, state.uuid!, "posts");
                    break;
                  case PostStatus.success:
                    await Future.delayed(const Duration(milliseconds: 500));
                    context.go("/"); context.push("/posts");
                    break;
                  case PostStatus.error:
                    break;
                }
              }
          ),
          BlocListener<UploadCubit, UploadState>(
            listener: (context, state) {
              switch (state.status) {
                case UploadStatus.init:
                  break;
                case UploadStatus.uploading:
                  context.read<PostCubit>().uploadPercent(state.percent!.toStringAsFixed(2));
                  break;
                case UploadStatus.success:
                  context.read<PostCubit>().updateImagesPost(state.urls ?? []);
                  break;
                case UploadStatus.error:
                  break;
              }
            },
          )
        ],
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _WritePostTitle(phoneWidth: phoneWidth),
                      _WritePostContent(phoneWidth: phoneWidth),
                      const SizedBox(height: 15.0),
                      _WritePostImage(phoneWidth: phoneWidth),
                    ],
                  )
                ],
              ),
            ),
            _EventPostWriteProcess(phoneWidth: phoneWidth)
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 40.0),
        child: ElevatedButton(
          onPressed: () {
            context.read<PostCubit>().changeUuid(const Uuid().v4()); // 게시글 고유번호 생성
            context.read<PostCubit>().changeDate(); // 현재 시간으로 등록하기 위함
            context.read<PostCubit>().save(); // 저장
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

class _WritePostTitle extends StatelessWidget {
  final double phoneWidth;

  const _WritePostTitle({
    required this.phoneWidth,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          title: "제목",
          fontSize: phoneWidth >= 400.0 ? 17.0 : 15.0,
          color: Colors.orangeAccent,
        ),
        TextField(
          onChanged: (value) {
            context.read<PostCubit>().changeTitle(value);
          },
          maxLength: 20,
          maxLines: 1,
          decoration: const InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orangeAccent)
            ),
            hintText: "제목을 입력해주세요.",
            prefixIcon: Icon(Icons.title,
              color: Colors.orangeAccent,
            ),
          ),
          style: TextStyle(
            fontFamily: "Jua",
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: phoneWidth >= 400.0 ? 17.0 : 15.0,
          ),
        )
      ],
    );
  }
}

class _WritePostContent extends StatelessWidget {
  final double phoneWidth;

  const _WritePostContent({
    required this.phoneWidth,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          title: "내용",
          fontSize: phoneWidth >= 400.0 ? 17.0 : 15.0,
          color: Colors.orangeAccent,
        ),
        SizedBox(
          height: 400,
          child: TextField(
            onChanged: (value) {
              context.read<PostCubit>().changeContent(value);
            },
            expands: true,
            maxLines: null,
            maxLength: 1000,
            decoration: const InputDecoration(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.orangeAccent)
              ),
              hintText: "내용을 입력해주세요.",
              prefixIcon: Padding(
                padding: EdgeInsets.only(bottom: 330.0),
                child: Icon(Icons.content_paste,
                  color: Colors.orangeAccent,
                ),
              ),
            ),
            style: TextStyle(
              fontFamily: "Jua",
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: phoneWidth >= 400.0 ? 17.0 : 15.0,
            ),
          ),
        ),
      ],
    );
  }
}

class _WritePostImage extends StatelessWidget {
  final double phoneWidth;

  const _WritePostImage({
    required this.phoneWidth,
    super.key});

  @override
  Widget build(BuildContext context) {
    final ImagePicker _picker = ImagePicker();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          title: "사진 첨부",
          fontSize: phoneWidth >= 400.0 ? 17.0 : 15.0,
          color: Colors.orangeAccent,
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          width: phoneWidth,
          height: phoneWidth >= 400.0 ? 60 : 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: BlocBuilder<PostCubit, PostState>(
                  builder: (context, state) {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.imageFiles.length + 1,
                      separatorBuilder: (context, index) => const SizedBox(width: 10.0),
                      itemBuilder: (context, index) {
                        if(index == state.imageFiles.length) {
                          return SizedBox(
                            width: phoneWidth >= 400.0 ? 60 : 55,
                            height: phoneWidth >= 400.0 ? 60 : 55,
                            child: GestureDetector(
                              onTap: () async {
                                var image = await _picker.pickImage(source: ImageSource.gallery);
                                context.read<PostCubit>().changePostImage(image);
                              },
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(color: Colors.black26, child: const Icon(Icons.add))
                              ),
                            ),
                          );
                        }

                        return SizedBox(
                          width: phoneWidth >= 400.0 ? 60 : 55,
                          height: phoneWidth >= 400.0 ? 60 : 55,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('안내'),
                                  content: const Text('등록하신 이미지 1개를 삭제 하시겠습니까?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('취소'),
                                      onPressed: () {
                                        Navigator.of(context).pop(); // 다이얼로그 닫기
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('확인'),
                                      onPressed: () {
                                        // 확인 버튼을 눌렀을 때 실행할 코드
                                        context.read<PostCubit>().deletePostImage(index);
                                        Navigator.of(context).pop(); // 다이얼로그 닫기
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(state.imageFiles[index], fit: BoxFit.fill)
                            ),
                          ),
                        );
                      },
                    );
                  }
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class _EventPostWriteProcess extends StatelessWidget {
  final double phoneWidth;

  const _EventPostWriteProcess({
    required this.phoneWidth,
    super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(
      buildWhen: (previous, current) => previous.percent != current.percent || previous.status != current.status,
      builder: (context, state) {
        if(state.percent != null && state.status == PostStatus.uploading) {
          return Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.black.withOpacity(0.8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  title: "[ 작성 중... ]",
                  fontSize: phoneWidth >= 400 ? 18.0 : 16.0,
                  color: Colors.yellow,
                ),
                const SizedBox(height: 10.0),
                const AppLoadingCircular(),
                const SizedBox(height: 10.0),
                AppText(
                  title: "${state.percent}%",
                  fontSize: phoneWidth >= 400 ? 16.0 : 14.0,
                )
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}