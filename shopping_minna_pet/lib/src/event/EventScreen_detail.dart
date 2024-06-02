import 'package:flutter/material.dart';
import 'package:shopping_minna_pet/src/common/component/app_text.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({Key? key}) : super(key: key);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}


class _EventDetailScreenState extends State<EventDetailScreen> {
  int review = 1;
  String? _selectedOption;
  late Widget _content;

  final List<Map<String, String>> _options = [
    {'title': '짱1', 'image': 'assets/app/best1.png', 'description': '한마디 각오?????'},
    {'title': '짱2', 'image': 'assets/app/best1.png', 'description': '델몬트'},
    {'title': '짱3', 'image': 'assets/app/best1.png', 'description': '그럼에도 '},
  ];
  @override
  void initState() {
    super.initState();
    _content = onApplyButtonPressed(review);
  }

  void updateContent(int newReview) {
    setState(() {
      review = newReview;
      _content = onApplyButtonPressed(review);
    });
  }

  Widget onApplyButtonPressed(int review) {
    /// 신청
    if (review == 1) {
      return SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: '이름',
                labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(width: 1, color: Colors.redAccent),
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(
                labelText: '애완동물 이름',
                labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(width: 1, color: Colors.redAccent),
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(
                labelText: '한마디 각오',
                labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(width: 1, color: Colors.redAccent),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 280.0,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 3, 199, 90),
                  surfaceTintColor: const Color.fromARGB(255, 3, 199, 90),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 30,
                  ),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const AppText(
                  title: "신청하기",
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
      /// 투표
    } else if (review == 2) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: _options.map((option) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RadioListTile<String>(
                        title: Text(option['title']!),
                        value: option['title']!,
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value;
                            _content = onApplyButtonPressed(2);
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            Image.asset(option['image']!,
                              height: 130,
                              width: 130,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 8),
                            Text(option['description']!, style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 280.0,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 3, 199, 90),
                  surfaceTintColor: const Color.fromARGB(255, 3, 199, 90),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 30,
                  ),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const AppText(
                  title: "신청하기",
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }
    /// 결과
    else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RankingCard(
              rank: "2nd",
              image: 'assets/app/eventD1.png',
              name: '서',
              score: '26,186',
              rankColor: Colors.blueGrey[100]!,
            ),
            RankingCard(
              rank: "1st",
              image: 'assets/app/eventD3.png',
              name: '유',
              score: '36,304',
              rankColor: Colors.yellow,
              isFirst: true,
            ),
            RankingCard(
              rank: "3rd",
              image: 'assets/app/eventD2.png',
              name: '정',
              score: '18,883',
              rankColor: Colors.brown,
            ),
          ],
        ),
      );
    }
  }


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
          title: '이벤트 상세보기',
          fontSize: 25,
          color: Colors.brown,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            AppText(
              title: "제 1회 대한민국 국견 대회",
              fontSize: 30,
              color: Colors.orangeAccent,
            ),
            Center(
              child: Container(
                width: 350,
                padding: const EdgeInsets.all(60),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.brown,
                    width: 3,
                  ),
                ),
                child: AppText(
                  title: '행사기간, 출전 자격:, 상금:,',
                  color: Colors.black,
                  fontSize: 15.0,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 3,
              width: double.maxFinite,
              color: Colors.brown,
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      review = 1;
                      _content = onApplyButtonPressed(review);
                    });
                  },
                  child: Text(
                    '신청',
                    style: TextStyle(
                      color: review == 1 ? Colors.pink : Colors.black38,
                      fontSize: 20.0,
                      fontWeight: review == 1 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      review = 2;
                      _content = onApplyButtonPressed(review);
                    });
                  },
                  child: Text(
                    '투표',
                    style: TextStyle(
                      color: review == 2 ? Colors.pink : Colors.black38,
                      fontSize: 20.0,
                      fontWeight: review == 2 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      review = 3;
                      _content = onApplyButtonPressed(review);
                    });
                  },
                  child: Text(
                    '결과',
                    style: TextStyle(
                      color: review == 3 ? Colors.pink : Colors.black38,
                      fontSize: 20.0,
                      fontWeight: review == 3 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: _content,
            ),
          ],
        ),
      ),
    );
  }
}

class RankingCard extends StatelessWidget {


  final String rank;
  final String image;
  final String name;
  final String score;
  final Color rankColor;
  final bool isFirst;
  //final VoidCallback onPressed;

  RankingCard({
    required this.rank,
    required this.image,
    required this.name,
    required this.score,
    required this.rankColor,
    this.isFirst = false,
   // required this.onPressed,
  });


  Widget build(BuildContext context) {
    return Column(
      children: [



          Icon(
            Icons.star,
            color: rankColor,
            size: 35,
          ),
        const SizedBox(height: 20),
        Container(
          width: isFirst ? 100 : 80,
          height: isFirst ? 100 : 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 20),

        Text(
          rank,
          style: TextStyle(
            fontSize: isFirst ? 24 : 20,
            fontWeight: isFirst ? FontWeight.bold : FontWeight.normal,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),

        Text(
          name,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),

        Text(
          score,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}