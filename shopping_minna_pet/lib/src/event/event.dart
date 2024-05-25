import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_minna_pet/src/common/component/app_text.dart';
import 'package:shopping_minna_pet/src/common/cubit/authentication_cubit.dart';
import 'package:shopping_minna_pet/src/post/post_cubit.dart';

import 'event_cubit.dart';

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
                        return SizedBox(
                          height: 180,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.network(
                              state.events!.items![index].eventImage!,
                              fit: BoxFit.fill,
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
