import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:shopping_minna_pet/src/common/cubit/navigation_cubit.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:group_button/group_button.dart';
import 'package:shopping_minna_pet/src/common/component/app_text.dart';
import 'package:shopping_minna_pet/src/sale/cubit/sale_drop_and_group_cubit.dart';

import '../common/component/app_dot_navigation_bar.dart';

class SaleScreen extends StatelessWidget {
  const SaleScreen({Key? key}) : super(key: key);

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
          SizedBox(
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
      appBar: AppBar(
        leading: Icon(Icons.notifications,
          color: Colors.brown[400],
          size: 40,
        ),
        title: Image.asset(
          "assets/app/logo2.png",
          width: 170,
          height: 130,
        ),
        centerTitle: true,
        actions: const [
          Icon(Icons.search,
            color: Colors.black, size: 45,
          ),
          Icon(Icons.shopping_cart,
            color: Colors.black, size: 45,
          ),
          SizedBox(width: 10.0),
        ],
      ),
      extendBody: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DropdownButton2<String>(
                isExpanded: true,
                hint: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppText(
                        title: "애완동물",
                        fontSize: 20.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                items: context.select<SaleDropGroupCubit, List<String>>((value) => value.state.dropItems!).map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: AppText(
                    title: item,
                    fontSize: 20.0,
                    color: Colors.orangeAccent,
                  ),)).toList(),
                value: context.select<SaleDropGroupCubit, String?>((value) => value.state.dropSelected),
                onChanged: (String? value) {
                  context.read<SaleDropGroupCubit>().changeDropSelected(value);
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
                    color: Colors.brown[50],
                  ),
                  elevation: 2,
                ),
                iconStyleData: const IconStyleData(
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
                      color: Colors.brown[50],
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
                    buttons: context.select<SaleDropGroupCubit, List<String>>((value) => value.state.groupItems!),
                    options: GroupButtonOptions(
                      selectedShadow: const [],
                      selectedTextStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.pink[900],
                      ),
                      selectedColor: Colors.brown[50],
                      unselectedShadow: const [],
                      unselectedColor: Colors.brown[50],
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
                    onSelected: (String value, int index, bool isSelected) {
                      // context.read<SaleDropGroupCubit>().changeGroupSelected(index);
                    }
                  ),
                ]
              )
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
                            ),
                          ]
                        )
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
      bottomNavigationBar: const AppDotNavgationBar(),
    );
  }
}