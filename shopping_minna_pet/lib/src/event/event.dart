import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_minna_pet/src/common/component/app_dot_navigation_bar.dart';
import 'package:shopping_minna_pet/src/common/component/app_text.dart';
import 'package:shopping_minna_pet/src/common/cubit/authentication_cubit.dart';
import 'package:shopping_minna_pet/src/post/cubit/post_cubit.dart';

import '../common/model/event_model.dart';
import 'cubit/event_cubit.dart';

class EventPageScreen extends StatefulWidget {
  const EventPageScreen({super.key});

  @override
  State<EventPageScreen> createState() => _EventPageScreenState();
}

class _EventPageScreenState extends State<EventPageScreen> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<EventCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const AppText(
          title: "이벤트",
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _writeButtonShowAndHide(),
                SizedBox(width: 10.0)
              ],
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: BlocBuilder<EventCubit, EventState>(
                builder: (context, state) {
                  if(state.status == PostStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  else if(state.events!.items!.isNotEmpty) {
                    return ListView.separated(
                      itemCount: state.events!.items!.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        return ImageWithText(
                          state.events!.items![index].eventImage!,
                          state.events!.items![index].eventProgress!,
                          state.events!.items![index],
                          context
                        );
                      },
                    );
                  }

                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        title: "진행중인 이벤트가 없어요 ㅠ.ㅠ",
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
      bottomNavigationBar: const AppDotNavgationBar(),
    );
  }

  Widget ImageWithText(String imagePath, String text, EventModel eventModel, BuildContext context) {
    return SizedBox(
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(imagePath,
                fit: BoxFit.fill,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    if(text == '참여하기' ||text == '투표하기'|| text == '결과확인') {
                      context.push('/eventdetail', extra: eventModel);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: text == "참여하기" ? const Color.fromARGB(255, 3, 199, 90)
                        : text == "투표하기" ? const Color.fromARGB(255, 254, 220, 0) : const Color.fromARGB(255, 255, 130, 69),
                    surfaceTintColor: text == "참여하기" ? const Color.fromARGB(255, 3, 199, 90)
                        : text == "투표하기" ? const Color.fromARGB(255, 254, 220, 0) : const Color.fromARGB(255, 255, 130, 69),
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
          ],
        ),
      ),
    );
  }
}

class _writeButtonShowAndHide extends StatelessWidget {
  const _writeButtonShowAndHide({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isAdminPermission = context.select<AuthenticationCubit, bool>((value) => value.state.user!.adminAccount!);
    if(isAdminPermission) {
      return TextButton(
          onPressed: () {
            context.push("/writeEvent");
          },
          child: const AppText(title: "[글쓰기] 클릭!", fontSize: 14.0, color: Colors.red,)
      );
    }
    return Container();
  }
}
