import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:shopping_minna_pet/src/common/cubit/navigation_cubit.dart';
import 'package:shopping_minna_pet/src/common/cubit/authentication_cubit.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:group_button/group_button.dart';
import 'package:shopping_minna_pet/src/common/component/app_text.dart';

class SaleScreen extends StatefulWidget {

  const SaleScreen({Key? key}) : super(key: key);
  @override
  _SaleScreenState createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  final List<String> items = [
    '강아지',
    '고양이',
    '토끼',
    '기니피그',
    '도마뱀',
    '기타',

  ];

  String? selectedValue;


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




  Widget ImageWithText2(String imagePath, String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        children: [
          Image.asset(
            imagePath,
            width: 150,
            height: 150,
            fit: BoxFit.fill,
          ),

          Container(

            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: AppText(
                  title: text,
                  fontSize: 19.0,
                  color: Colors.redAccent,
                ),
                
              ),
            ),
          ),

        ],
      ),

    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              ///
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.notifications,
                    color: Colors.brown[400],
                    size: 40,

                  ),
                  Image.asset(
                    "assets/app/logo2.png",
                    width: 170,
                    height: 130,

                  ),
                  Container(
                      child: Row(
                          children: [Icon(Icons.search,
                            color: Colors.black, size: 45,),
                            Icon(Icons.shopping_cart,
                              color: Colors.black, size: 45,)
                          ]))

                ],),
        Row(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: [
          DropdownButton2<String>(
          isExpanded: true,
          hint:  Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: AppText(
                  title: "애완동물",
                  fontSize: 20.0,
                  color: Colors.orangeAccent,
                ),
              ),
            ],
          ),
                  items: items
                      .map((String item) =>
                      DropdownMenuItem<String>(
                        value: item,
                        child: AppText(
                          title: item,
                          fontSize: 20.0,
                          color: Colors.orangeAccent,
                        ),
                      ))
                      .toList(),
                  value: selectedValue,
                  onChanged: (String? value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 40,
                    width: 120,
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.brown[50]!,
                        //color: Colors.amber[900]!,
                      ),
                      color: Colors.pink[50],
                    ),
                    elevation: 2,
                  ),
                  iconStyleData:  IconStyleData(
                    icon: Icon(
                      Icons.arrow_drop_down_circle_outlined,
                    ),
                    iconSize: 20,
                    iconEnabledColor: Colors.orangeAccent,
                    iconDisabledColor: Colors.orangeAccent,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.black38,
                      ),
                      color: Colors.pink[50],
                    ),
                    //offset: const Offset(0, 0),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(10),
                      thickness: MaterialStateProperty.all(6),
                      thumbVisibility: MaterialStateProperty.all(true),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 50,
                  ),
                ),
              ],
            ),
              const SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                  child:
                  Row(children: [
                    GroupButton(
                      isRadio: true,
                      buttons: ["전체", "세일", "의류", "사료", "간식", "장난감","미용", "기타"],
                      options: GroupButtonOptions(
                        selectedShadow: const [],
                        selectedTextStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.pink[900],
                        ),
                        selectedColor: Colors.pink[100],
                        unselectedShadow: const [],
                        unselectedColor: Colors.pink[50],
                        unselectedTextStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.amber[900],
                        ),
                        selectedBorderColor: Colors.pink[900],
                        unselectedBorderColor: Colors.brown[50],
                        borderRadius: BorderRadius.circular(100),
                        spacing: 15,
                        runSpacing: 20,
                        groupingType: GroupingType.wrap,
                        direction: Axis.horizontal,
                        buttonHeight: 40,
                        buttonWidth: 60,
                        mainGroupAlignment: MainGroupAlignment.start,
                        crossGroupAlignment: CrossGroupAlignment.start,
                        groupRunAlignment: GroupRunAlignment.start,
                        textAlign: TextAlign.center,
                        textPadding: EdgeInsets.zero,
                        alignment: Alignment.center,
                        elevation: 0,
                      ),


                      onSelected: (String value, int index, bool isSelected) =>
                          print('$value button at index $index is selected: $isSelected'),

                    ),


                  ])
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: AppText(
                        title: "추천",
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
                          ImageWithText('assets/app/best1.png', ''),
                          ImageWithText('assets/app/best2.png', ''),
                          ImageWithText('assets/app/best3.png', ''),
                        ],
                      ),


                    ),


                    const SizedBox(height: 20),
                    AppText(
                      title: "선택한 종 / 전체",
                      fontSize: 25.0,
                      color: Colors.brown[400],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            context.push('/saledetail');
                          },
                          child: Column(
                            children: [Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ImageWithText2('assets/app/example.png', '주문제작 가능'),

                                ImageWithText2('assets/app/example2.png', ''),

                              ],
                            ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  ImageWithText2('assets/app/example3.png', ''),
                                  ImageWithText2('assets/app/example4.png', '주문제작 가능'),

                                ],


                              ),])


                        ),
                      ],
                    )


                  ],
                ),
              ),
            ],
          ),
      ),


      // 하단 네비게이션 바
      bottomNavigationBar: DotNavigationBar(
        itemPadding: const EdgeInsets.all(14),
        marginR: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        paddingR: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        currentIndex: context.select<NavigationCubit, int>((value) =>
        value.state.selectedNum!),
        onTap: (index) {
          context.read<NavigationCubit>().handleIndexChanged(index, context);
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