import 'package:card_swiper/card_swiper.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_minna_pet/src/common/component/app_text.dart';
import 'package:shopping_minna_pet/src/common/cubit/authentication_cubit.dart';
import 'package:shopping_minna_pet/src/common/cubit/navigation_cubit.dart';
import 'package:shopping_minna_pet/src/event/event_cubit.dart';

import 'common/component/app_dot_navigation_bar.dart';
import 'common/component/app_loading_circular.dart';

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
                    // 커뮤니티
                    const _CommunityScreen(),
                    const _LocationScreen(),
                  ]
                ),
              ],
            );
          }
        ),
      ),
      // 하단 네비게이션 바
      bottomNavigationBar: const AppDotNavgationBar()
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
            backgroundColor: MaterialStatePropertyAll(Colors.white),
            trailing: [Icon(Icons.search)],
            shadowColor: MaterialStatePropertyAll(Colors.black),
            constraints: BoxConstraints(maxWidth: 180, maxHeight: 200),
          ),
        ),
        const SizedBox(width: 5.0),
        InkWell(
          onTap: () {
            context.read<NavigationCubit>().handleIndexChanged(4, context);
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
    return BlocBuilder<EventCubit, EventState> (
      builder: (context, state) {
        if (state.status == EventStatus.loading) {
          return const Center(child: AppLoadingCircular());
        }

        if (state.imageBannerList != null && state.imageBannerList!.isNotEmpty) {
          return GestureDetector(
            onTap: () {
              context.push("/events");
            },
            child: SizedBox(
              height: 200,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(
                      state.imageBannerList![index],
                      fit: BoxFit.fill,
                    ),
                  );
                },
                autoplay: true,
                duration: 1000,
                itemCount: state.imageBannerList!.length,
                viewportFraction: 0.9,
                scale: 0.8,
                pagination: const SwiperPagination(),
                control: const SwiperControl(
                  padding: EdgeInsets.only(left: 7.0),
                  color: Colors.grey,
                ),
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: () {
            context.push("/events");
          },
          child: const SizedBox(
            height: 200,
            child: Center(
              child: AppText(
                title: "진행중인 이벤트가 없어요 ㅠㅠ",
                fontSize: 18.0,
                color: Colors.black,
              )
            )
          ),
        );
      }
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

        InkWell(
          onTap: () {
            context.push('/saledetail');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ImageWithText('assets/app/best1.png', '1'),
              ImageWithText('assets/app/best2.png', '2'),
              ImageWithText('assets/app/best3.png', '3'),
            ],
          ),


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
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                InputDecorator(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(20,62,10,0),
                    labelText: '  게시판',
                    labelStyle: const TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0,),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.brown,width:10 ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child:TextButton(
                            onPressed: () {
                              context.push("/posts");
                            },
                            child: const AppText(
                              title: '최근',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )
                        ),

                      ),

                      Text('익명 1 : 나눔 공지!!!! 선착순입니다 오늘까지 연락 주세요 '),
                      Align(
                        alignment: Alignment.centerLeft,
                        child:TextButton(
                            onPressed: () {
                              context.push("/posts");
                            },
                            child: const AppText(
                              title: '베스트',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )
                        ),

                      ),
                      Text('익명 2 : 왕앙아앙 우주 최강 짱 귀여미 저희 집 고양이 자랑 좀 하겠습니닷ㅇ ㅎㅎ'),
                    ],
                  ),
                ),
              ],
            ),
          ),


        ]
      ),
    );
  }
}

class _LocationScreen extends StatelessWidget {
  const _LocationScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top:10, right:30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title: '출입 가능 가게',
            fontSize: 25.0,
            color: Colors.orangeAccent,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _AmenitiesRow(
                  imagePath: "assets/app/shop.png",
                  titleName: "애견샵",
                  type: "shop",
                //imageWidth: 00.0,
                // imageHeight: 00.0,
              ),
              // SizedBox(width: 50.0),
              _AmenitiesRow(
                imagePath: "assets/app/hospital.png",
                titleName: "병원",
                type: "hospital",
                //imageWidth: 00.0,
                //imageHeight: 00.0,

              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _AmenitiesRow(
                imagePath: "assets/app/restaurant.png",
                titleName: "음식점",
                type: "restaurant",
                //imageWidth: 00.0,
                // imageHeight: 00.0,
              ),

              // SizedBox(width: 50.0),
              _AmenitiesRow(
                imagePath: "assets/app/park.png",
                titleName: "공원",
                type: "park",

              ),
            ],
          )
        ],
      ),
    );
  }
}
class _AmenitiesRow extends StatelessWidget {
  final String imagePath;
  final String titleName;
  final String type;
  //final double imageWidth;
 // final double imageHeight;

  const _AmenitiesRow({
    required this.imagePath,
    required this.titleName,
    required this.type,
    //required this.imageWidth,
    //required this.imageHeight,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () => context.push("/app/$type"),
              icon: Image.asset(imagePath,
                //width: 100,
                //height: 100,
              )
          ),
          const SizedBox(width: 3.0),
          Text(titleName,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold
            ),
          ),
        ]
    );
  }
}