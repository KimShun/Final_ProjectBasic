import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_minna_pet/src/common/component/app_text.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({Key? key}) : super(key: key);

  @override
  _BasketScreenState createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {

  final List<CartItemModel> _cartItems = [
    CartItemModel(imagePath: "assets/app/sale1.png", title: '세최이드레스', price: '30000'),
    CartItemModel(imagePath: "assets/app/sale2.png", title: '세최이드레스', price: '30000'),
    CartItemModel(imagePath: "assets/app/sale3.png", title: '세최이드레스', price: '30000'),

  ];


  final List<bool> _isCheckedList = [false, false,false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.amber,
          iconSize: 35,
          icon: Icon(Icons.arrow_back),
        ),
        title: const AppText(
          title: '장바구니',
          fontSize: 25,
          color: Colors.brown,
        ),
        centerTitle: true,
        actions: const [
          Icon(
            Icons.notifications,
            color: Colors.brown,
            size: 40,
          ),
          SizedBox(width: 10.0),
        ],
      ),
      body: Column(
        children: [
          Container(
              height: 2, width: double.maxFinite, color: Colors.black87),
          const SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    IconButton(
                      onPressed: () => context.push('/saledetail'),
                      icon: Image.asset(
                        _cartItems[index].imagePath,
                        width: 130,
                        height: 130,
                      ),
                    ),
                    const SizedBox(width: 40.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          title: _cartItems[index].title,
                          fontSize: 25,
                          color: Colors.black,
                        ),
                        AppText(
                          title: _cartItems[index].price,
                          fontSize: 25,
                          color: Colors.pinkAccent,
                        ),
                      ],
                    ),
                    SizedBox(width: 30.0),
                    Checkbox(
                      value: _isCheckedList[index],
                      onChanged: (value) {
                        setState(() {
                          _isCheckedList[index] = value!;
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 280.0,
              child: ElevatedButton(
                onPressed: () {

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 3, 199, 90),
                  surfaceTintColor: const Color.fromARGB(255, 3, 199, 90),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 30),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const AppText(
                  title: "주문하기",
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItemModel {
  final String title;
  final String price;
  final String imagePath;

  CartItemModel({
    required this.title,
    required this.price,
    required this.imagePath,
  });
}
