import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_minna_pet/src/common/component/app_text.dart';
import 'package:shopping_minna_pet/src/common/component/color.dart';
import 'package:shopping_minna_pet/src/common/cubit/authentication_cubit.dart';

import '../common/component/app_dot_navigation_bar.dart';
import '../common/model/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const _ProfileHeadingMenu(),
              const SizedBox(height: 5.0),
              Expanded(
                child: ListView(
                  children: [
                    const _UserCardWidget(),
                    const SizedBox(height: 5.0),
                    const Divider(color: Colors.black38, thickness: 2),
                    const SizedBox(height: 5.0),
                    _UserUsageWidgets(userModel: context.select<AuthenticationCubit, UserModel>((value) => value.state.user!),),
                    const SizedBox(height: 15.0),
                    const _ProfileSelects(),
                    const SizedBox(height: 5.0),
                    _UserShowUidAndID(context)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppDotNavgationBar(),
    );
  }

  Widget _UserShowUidAndID(BuildContext context) {
    return Center(
      child: Column(
        children: [
          AppText(
            title: "Uid: ${context.select<AuthenticationCubit, String?>((value) => value.state.user!.uid!)}",
            fontSize: 12.0,
            color: Colors.black26,
            fontWeight: FontWeight.normal,
          ),
          AppText(
            title: "Platform: ${context.select<AuthenticationCubit, String?>((value) => value.state.user!.platform!)}",
            fontSize: 12.0,
            color: Colors.black26,
            fontWeight: FontWeight.normal,
          ),
        ],
      ),
    );
  }
}

class _ProfileHeadingMenu extends StatelessWidget {
  const _ProfileHeadingMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () => _logoutDialog(context),
          icon: const Icon(Icons.logout),
          iconSize: 24.0,
          color: Colors.red,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications),
          iconSize: 24.0,
        ),
      ],
    );
  }

  Future<void> _logoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('안내'),
        content: const Text('정말로 로그아웃 하시겠습니까?'),
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
              context.read<AuthenticationCubit>().logout();
              context.go("/login");
            },
          ),
        ],
      ),
    );
  }
}

class _UserCardWidget extends StatelessWidget {
  const _UserCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.black26,
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => context.push("/modifyProfile"),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: BG_COLOR
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: Image.network(state.user!.profile!).image,
                            radius: 40.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                title: state.user!.name!,
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                              AppText(
                                title: "${state.user!.petName == null || state.user!.petName == "" ? "정보없음(펫 이름)" : state.user!.petName} "
                                    "/ ${state.user!.petType == null || state.user!.petType == "" ? "정보없음(펫 타입)" : state.user!.petType}",
                                fontSize: 12.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                              ),
                              AppText(
                                title: "${state.user!.petBirthday == null || state.user!.petBirthday == "" ? "정보없음(펫 생일)" : state.user!.petBirthday}",
                                fontSize: 12.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                              )
                            ],
                          ),
                          const Icon(Icons.arrow_right)
                        ],
                      );
                    }
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: BG_COLOR
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _informationCouponWidget("보유쿠폰 : ${context.select<AuthenticationCubit, int>((value) => value.state.user!.coupons!.length)}개", Icons.wallet_giftcard),
                    Container(height: 23, decoration: BoxDecoration(border: Border.all(color: Colors.black54, width: 1.0))),
                    _informationCouponWidget("보유포인트 : ${context.select<AuthenticationCubit, int>((value) => value.state.user!.point!)}원", Icons.money)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _informationCouponWidget(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon,
          size: 26.0,
        ),
        const SizedBox(width: 10.0),
        AppText(
          title: title,
          fontSize: 13.0,
          color: Colors.black,
        ),
      ],
    );
  }
}

class _UserUsageWidgets extends StatelessWidget {
  final UserModel userModel;

  const _UserUsageWidgets({
    required this.userModel,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _UserUsageWidget(Icons.favorite, "좋아요한 글", () {context.push("/myLikePosts");}),
        _UserUsageWidget(Icons.find_in_page, "작성한 글", () {context.push("/myWrittenPosts", extra: userModel);}),
        _UserUsageWidget(Icons.event_available, "이벤트내역", () {context.push("/myEventJoined");}),
        _UserUsageWidget(Icons.shopping_cart, "구매내역", () {context.push("/myPurchased");}),
      ],
    );
  }

  Widget _UserUsageWidget(IconData icon, String title, Function() pushPage) {
    return GestureDetector(
      onTap: pushPage,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(icon,
                color: Colors.black87,
                size: 40.0,
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          AppText(
            title: title,
            fontSize: 15.0,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          )
        ],
      ),
    );
  }
}

class _ProfileSelects extends StatelessWidget {
  const _ProfileSelects({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProfileSelect("고객센터"),
        const SizedBox(height: 10.0),
        _ProfileSelect("설정"),
        const SizedBox(height: 5.0),
        const Divider(color: Colors.black12, thickness: 1),
        const SizedBox(height: 5.0),
        _ProfileSelect("회원탈퇴"),
      ],
    );
  }

  Widget _ProfileSelect(String title) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                title: title,
                fontSize: 15.0,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
              const Icon(Icons.arrow_right)
            ],
          ),
        ),
      ),
    );
  }
}