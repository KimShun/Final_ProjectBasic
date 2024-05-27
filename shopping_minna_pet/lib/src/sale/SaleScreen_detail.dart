import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:shopping_minna_pet/src/common/cubit/navigation_cubit.dart';
import 'package:shopping_minna_pet/src/common/cubit/authentication_cubit.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:shopping_minna_pet/src/common/component/app_text.dart';

List<String> bannerImageList = ["assets/app/sale1.png", "assets/app/sale2.png","assets/app/sale3.png"];

class SaleDetailScreen extends StatefulWidget {

  const SaleDetailScreen({Key? key}) : super(key: key);
  @override
  _SaleDetailScreenState createState() => _SaleDetailScreenState();
}

class _SaleDetailScreenState extends State<SaleDetailScreen> {
  @override
  int review =0;
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                    onPressed: () {
                        Navigator.pop(context); //뒤로가기
                        },
                    color: Colors.amber,
                        iconSize: 35,
                    icon: Icon(Icons.arrow_back)),

                    Image.asset(
                      "assets/app/logo2.png",
                      width: 150,
                      height: 130,

                    ),
                    Container(
                        child: Row(
                            children: [Icon(Icons.search,
                              color: Colors.black, size: 40,),
                              Icon(Icons.shopping_cart,
                                color: Colors.black, size: 40,)
                            ]))

                  ],
                ),
                Expanded(
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 200,
                        child: Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image.asset(
                                bannerImageList[index],
                                fit: BoxFit.fill,
                              ),
                            );
                          },
                          autoplay: true,
                          duration: 1000,
                          itemCount: bannerImageList.length,
                          viewportFraction: 0.9,
                          scale: 0.8,
                          pagination: const SwiperPagination(),

                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                          height: 1,
                          width: double.maxFinite,
                          color: Colors.black
                      ),


                      Row(
                        children: [
                          Expanded(
                            child:
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 40),
                            child:
                            Column(
                              children: [
                                AppText(
                                  title: "슈퍼스타 원피스 블랙",
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                AppText(
                                  title: "28,000원",
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pinkAccent,
                                )
                              ],
                            ),),
                          ),
                          Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.black,
                            size: 60,
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),
                      Container(
                          height: 1,
                          width: double.maxFinite,
                          color: Colors.black
                      ),

                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              review=1;
                            });
                          },
                          child: Text('상품 정보',
                            style: TextStyle(
                              color: review == 1 ? Colors.pink : Colors.black38,
                              fontSize: 20.0,
                              fontWeight: review == 1 ? FontWeight.bold : FontWeight.normal,
                            ),
                          )
                      ),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              review=2;
                            });
                          },
                          child: Text('리뷰',
                            style: TextStyle(
                              color: review == 2 ? Colors.pink : Colors.black38,
                              fontSize: 20.0,
                              fontWeight: review == 2 ? FontWeight.bold : FontWeight.normal,
                            ),
                          )
                      ),

                    ],
                  ),
                  ]
                ),
                )
              ],
          ),
      ),
      bottomNavigationBar: Padding(
        padding:const EdgeInsets.only(right:200,left: 10),
        child: Row(
          children: [
            ElevatedButton(
            onPressed: () {
              // 로그인 버튼 클릭 시 동작을 여기에 추가합니다.
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 3, 199, 90),
              surfaceTintColor: Color.fromARGB(255, 3, 199, 90),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal:30),
              textStyle: TextStyle(fontSize: 20),
              //primary: Colors.green,
            ),
            child: const AppText(
              title: "구매하기",
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )


          ),
            const SizedBox(width: 15),
            Icon(
              Icons.shopping_cart,
              color: Colors.amber,
              size: 40,
            ),],

        ),

      ),
    );
  }
}