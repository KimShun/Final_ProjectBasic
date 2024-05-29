import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_minna_pet/src/event/event_cubit.dart';
import 'package:uuid/uuid.dart';

import '../common/component/app_loading_circular.dart';
import '../common/component/app_text.dart';
import '../common/cubit/upload_cubit.dart';

class WriteEventScreen extends StatelessWidget {
  const WriteEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double phoneWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const AppText(
          title: "이벤트 게시하기",
          fontSize: 23.0,
          textDecoration: TextDecoration.underline,
          color: Colors.black,
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<EventCubit, EventState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              switch (state.status) {
                case EventStatus.init:
                  break;
                case EventStatus.loading:
                  break;
                case EventStatus.uploading:
                  context.read<UploadCubit>().uploadImage(state.eventImage!, state.uuid!, "events", "event_banner");
                  break;
                case EventStatus.success:
                  context.read<EventCubit>().HomeBannerLoad();
                  context.go("/");
                  break;
                case EventStatus.error:
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
                  context.read<EventCubit>().uploadPercent(state.percent!.toStringAsFixed(2));
                  break;
                case UploadStatus.success:
                  context.read<EventCubit>().updateImageEventBanner(state.url!);
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
                  // 이벤트 이미지 배너 설정
                  _EventImageBanner(),
                  const SizedBox(height: 10.0),
                  const Divider(color: Colors.black54),
                  const SizedBox(height: 10.0),
                  // 이벤트 제목, 내용 입력
                  _EventDetailField(phoneWidth: phoneWidth),
                  const SizedBox(height: 20.0),
                  // 이벤트 진행상태 여부 (토글스위치) - 모집중 / 투표중
                  _changeModeToggle(phoneWidth: phoneWidth),
                  const SizedBox(height: 20.0),
                  // 취소 및 확인 버튼
                  _WriteEventBtn(phoneWidth: phoneWidth,),
                ],
              ),
            ),
            _EventPostWriteProcess(phoneWidth: phoneWidth),
          ]
        ),
      ),
    );
  }
}

class _EventImageBanner extends StatelessWidget {
  _EventImageBanner({super.key});
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var bannerImage = context.select<EventCubit, File?>((value) => value.state.eventImage);

    return GestureDetector(
      onTap: () async {
        var image = await _picker.pickImage(source: ImageSource.gallery);
        context.read<EventCubit>().changeImage(image);
      },
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: bannerImage == null ? Container(color: Colors.grey, child: const Center(child: Icon(Icons.add, size: 30.0,)))
                  : Image.file(bannerImage, fit: BoxFit.fill,)
            ),
          ),
          const SizedBox(height: 10.0),
          AppText(
            title: "[ 이벤트배너 이미지를 설정해주세요. ]",
            fontSize: MediaQuery.of(context).size.width >= 400 ? 16.0 : 14.0,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}

class _EventDetailField extends StatelessWidget {
  final double phoneWidth;

  const _EventDetailField({
    required this.phoneWidth,
    super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                title: "제목",
                fontSize: phoneWidth >= 400.0 ? 17.0 : 15.0,
                color: Colors.orangeAccent,
              ),
              TextField(
                onChanged: (value) {
                  context.read<EventCubit>().changeTitle(value);
                },
                maxLength: 20,
                maxLines: 1,
                decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orangeAccent)
                    ),
                    hintText: "이벤트 제목을 입력하세요.",
                    prefixIcon: Icon(Icons.title, color: Colors.orangeAccent,)
                ),
                style: TextStyle(
                  fontFamily: "Jua",
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: phoneWidth >= 400.0 ? 17.0 : 15.0,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                title: "내용",
                fontSize: phoneWidth >= 400.0 ? 17.0 : 15.0,
                color: Colors.orangeAccent,
              ),
              SizedBox(
                height: 300,
                child: TextField(
                  onChanged: (value) {
                    context.read<EventCubit>().changeContent(value);
                  },
                  expands: true,
                  maxLines: null,
                  maxLength: 1000,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orangeAccent)
                    ),
                    hintText: "이벤트 내용을 입력하세요.",
                    prefixIcon: Padding(
                        padding: EdgeInsets.only(bottom: 230.0),
                        child: Icon(Icons.abc, color: Colors.orangeAccent,)
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
          ),
        ],
      )
    );
  }
}

class _changeModeToggle extends StatelessWidget {
  final double phoneWidth;

  const _changeModeToggle({
    required this.phoneWidth,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        AppText(
          title: "모드선택(모집중/투표중)",
          fontSize: phoneWidth >= 400.0 ? 18.0 : 16.0,
          color: Colors.orangeAccent,
        ),
        Switch(
          value: context.select<EventCubit, bool>((value) => value.state.mode),
          onChanged: (value) {
            context.read<EventCubit>().changeMode(value);
          },
          inactiveTrackColor: Colors.white12,
          activeColor: Colors.orange[400],
        ),
      ],
    );
  }
}

class _WriteEventBtn extends StatelessWidget {
  final double phoneWidth;

  const _WriteEventBtn({
    required this.phoneWidth,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: AppText(
                title: "취소..",
                fontSize: phoneWidth >= 400 ? 20.0 : 18.0,
              ),
            )
        ),
        const SizedBox(width: 15.0),
        ElevatedButton(
            onPressed: () {
              context.read<EventCubit>().changeUuid(const Uuid().v4()); // 게시글 고유번호 생성
              context.read<EventCubit>().changeDate(DateTime.now()); // 현재 시간으로 등록하기 위함
              context.read<EventCubit>().save();
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
                title: "작성완료!!",
                fontSize: phoneWidth >= 400 ? 20.0 : 18.0,
              ),
            )
        ),
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
    return BlocBuilder<EventCubit, EventState>(
      buildWhen: (previous, current) => previous.percent != current.percent || previous.status != current.status,
      builder: (context, state) {
        if(state.percent != null && state.status == EventStatus.uploading) {
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
