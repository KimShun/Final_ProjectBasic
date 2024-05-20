import 'package:card_swiper/card_swiper.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_minna_pet/src/common/component/app_text.dart';
import 'package:shopping_minna_pet/src/common/cubit/authentication_cubit.dart';
import 'package:shopping_minna_pet/src/common/cubit/navigation_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: BlocBuilder<AuthenticationCubit, AuthenticationState> (
          builder: (context, state) {
            return ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 로고, 검색창, 프로필
                    _TopHomeScreen(profileImage: state.user!.profile!),
                    // 이벤트 배너
                    const _HomeEventBanner(),
                    const SizedBox(height: 30),
                    // 인기상품 1~3위
                    const _TopSellerScreen(),
                    const SizedBox(height: 30),
                    ///커뮤니티
                    const _CommunityScreen()
                  ]
                ),
              ],
            );
          }
        ),
      ),
      // 하단 네비게이션 바
      bottomNavigationBar: DotNavigationBar(
        itemPadding: const EdgeInsets.all(14),
        marginR: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        paddingR: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        currentIndex: context.select<NavigationCubit, int>((value) => value.state.selectedNum!),
        onTap: (index) {
          context.read<NavigationCubit>().handleIndexChanged(index);
          context.read<NavigationCubit>().changePage(context);
        },
        // dotIndicatorColor: Colors.black,
        items: [
          DotNavigationBarItem(
            icon: const Icon(Icons.pets),
            selectedColor: Colors.brown,
          ),
          DotNavigationBarItem(
            icon: const Icon(Icons.search),
            selectedColor: Colors.orange,
          ),
          DotNavigationBarItem(
            icon: const Icon(Icons.home),
            selectedColor: Colors.purple,
          ),
          DotNavigationBarItem(
            icon: const Icon(Icons.shopping_cart),
            selectedColor: Colors.black12,
          ),
          DotNavigationBarItem(
            icon: const Icon(Icons.person),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}

class _TopHomeScreen extends StatelessWidget {
  final String profileImage;
  
  const _TopHomeScreen({
    required this.profileImage,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(
          "assets/app/logo.png",
          width: 100,
          height: 110,
        ),
        const SizedBox(
          height: 35,
          child: SearchBar(
            trailing: [Icon(Icons.search)],
            shadowColor: MaterialStatePropertyAll(Colors.black),
            constraints: BoxConstraints(maxWidth: 180, maxHeight: 200),
          ),
        ),
        const SizedBox(width: 5.0),
        InkWell(
          onTap: () {
            context.go('/profile');
          },
          child: CircularProfileAvatar(
            profileImage,
            borderColor: Colors.brown,
            borderWidth: 3,
            elevation: 2,
            radius: 30,
          ),
        ),
        const SizedBox(width: 10.0),
      ],
    );
  }
}

class _HomeEventBanner extends StatelessWidget {
  const _HomeEventBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.asset(
              'assets/app/event1.jpg',
              fit: BoxFit.fill,
            ),
          );
        },
        autoplay: true,
        duration: 1000,
        itemCount: 4,
        viewportFraction: 0.9,
        scale: 0.8,
        pagination: const SwiperPagination(),
        control: const SwiperControl(
          padding: EdgeInsets.only(left: 7.0),
          color: Colors.grey,
        ),
      ),
    );
  }
}

class _TopSellerScreen extends StatelessWidget {
  const _TopSellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: AppText(
            title: "Best",
            fontSize: 25.0,
            color: Colors.orangeAccent,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ImageWithText('assets/app/best1.png', '1'),
            ImageWithText('assets/app/best2.png', '2'),
            ImageWithText('assets/app/best3.png', '3'),
          ],
        ),
      ],
    );
  }

  Widget ImageWithText(String imagePath, String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        children: [
          Image.asset(
            imagePath,
            width: 100,
            height: 100,
            fit: BoxFit.fill,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0)
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: AppText(
                  title: text,
                  fontSize: 19.0,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommunityScreen extends StatelessWidget {
  const _CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                InputDecorator(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(20,62,10,50),
                    labelText: '  게시판',
                    labelStyle: const TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0,),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.brown,width:10 ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          context.push("/posts");
                        },
                        child: const Text(
                          '최근',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          '베스트',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20.0),
          Container(
            padding: const EdgeInsets.all(80),
            decoration: BoxDecoration(
              color: Colors.amber[200],
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            )
          ),
        ]
      ),
    );
  }
}
