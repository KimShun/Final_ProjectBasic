import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_minna_pet/src/common/component/app_text.dart';
import 'package:shopping_minna_pet/src/common/cubit/authentication_cubit.dart';
import 'package:shopping_minna_pet/src/event/cubit/event_cubit.dart';

import '../common/component/app_loading_circular.dart';
import '../common/cubit/upload_cubit.dart';
import '../common/model/event_model.dart';

class EventDetailScreen extends StatefulWidget {
  final EventModel eventModel;

  const EventDetailScreen({
    required this.eventModel,
    Key? key}) : super(key: key);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}


class _EventDetailScreenState extends State<EventDetailScreen> {
  int review = 1;
  String? _selectedOption;
  late Widget _content;

  @override
  void initState() {
    super.initState();
    _content = onApplyButtonPressed(review, widget.eventModel);
  }

  void updateContent(int newReview) {
    setState(() {
      review = newReview;
      _content = onApplyButtonPressed(review, widget.eventModel);
    });
  }

  Widget onApplyButtonPressed(int review, EventModel eventModel) {
    /// 신청
    if (review == 1) {
      return BlocBuilder<EventCubit, EventState>(
        builder: (context, state) {
          final ImagePicker _picker = ImagePicker();

          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) => context.read<EventCubit>().changeSignName(value),
                      controller: state.signName,
                      decoration: const InputDecoration(
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
                      onChanged: (value) => context.read<EventCubit>().changeSignPetName(value),
                      controller: state.signPetName,
                      decoration: const InputDecoration(
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
                      onChanged: (value) => context.read<EventCubit>().changeSignResolve(value),
                      controller: state.signResolve,
                      decoration: const InputDecoration(
                        labelText: '한마디 각오',
                        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 1, color: Colors.redAccent),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        var image = await _picker.pickImage(source: ImageSource.gallery);
                        context.read<EventCubit>().changeSignEventImage(image);
                      },
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: state.signEventImage == null ? Container(color: Colors.grey, child: const Center(child: Icon(Icons.add)),)
                                : Image.file(state.signEventImage!, fit: BoxFit.fill)
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: 280.0,
                      child: ElevatedButton(
                        onPressed: () => context.read<EventCubit>().userEventSignSave(widget.eventModel),
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
              ),
              _AlreadySignEvent(uuid: widget.eventModel.uuid!, eventProcess: widget.eventModel.eventProgress!),
            ],
          );
        }
      );
      /// 투표
    } else if (review == 2) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: eventModel.userEventSign!.map((option) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RadioListTile<String>(
                        title: Text(option['signName']!),
                        value: option['signName']!,
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value;
                            _content = onApplyButtonPressed(2, widget.eventModel);
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            Image.network(option['imageUrl']!,
                              height: 130,
                              width: 130,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 8),
                            Text(option['resolve']!, style: TextStyle(fontSize: 16)),
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
    final userUid = context.select<AuthenticationCubit, String>((value) => value.state.user!.uid!);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.amber,
          iconSize: 35,
          icon: const Icon(Icons.arrow_back),
        ),
        title: const AppText(
          title: '이벤트 상세보기',
          fontSize: 25,
          color: Colors.brown,
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<EventCubit, EventState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) async {
              switch (state.status) {
                case EventStatus.init:
                  break;
                case EventStatus.loading:
                  break;
                case EventStatus.uploading:
                  context.read<UploadCubit>().uploadImage(
                      state.signEventImage!, state.eventModel!.uuid!, "events/${state.eventModel!.uuid!}", userUid);
                  break;
                case EventStatus.success:
                  context.read<AuthenticationCubit>().reloadAuth();
                  break;
                case EventStatus.error:
                  break;
              }
            }
          ),
          BlocListener<UploadCubit, UploadState>(
            listener: (context, state) {
              switch (state.status) {
                case UploadStatus.init:
                  break;
                case UploadStatus.uploading:
                  context.read<EventCubit>().uploadPercent(state.percent!.toStringAsFixed(2));
                  break;
                case UploadStatus.success:
                  context.read<EventCubit>().updateUserEventImage(state.url!);
                  break;
                case UploadStatus.error:
                  break;
              }
            },
          )
        ],
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  AppText(
                    title: widget.eventModel.title!,
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
                        title: widget.eventModel.content!,
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
                            _content = onApplyButtonPressed(review, widget.eventModel);
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
                            _content = onApplyButtonPressed(review, widget.eventModel);
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
                            _content = onApplyButtonPressed(review, widget.eventModel);
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
            const _EventPostWriteProcess(),
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

class _EventPostWriteProcess extends StatelessWidget {
  const _EventPostWriteProcess({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCubit, EventState>(
      buildWhen: (previous, current) => previous.percent != current.percent || previous.status != current.status,
      builder: (context, state) {
        if(state.percent != null && state.status == EventStatus.uploading) {
          return Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.black.withOpacity(0.8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppText(
                  title: "[ 신청 중... ]",
                  fontSize: 16.0,
                  color: Colors.yellow,
                ),
                const SizedBox(height: 10.0),
                const AppLoadingCircular(),
                const SizedBox(height: 10.0),
                AppText(
                  title: "${state.percent}%",
                  fontSize: 14.0,
                )
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class _AlreadySignEvent extends StatelessWidget {
  final String uuid;
  final String eventProcess;

  const _AlreadySignEvent({
    required this.uuid,
    required this.eventProcess,
    super.key});

  @override
  Widget build(BuildContext context) {
    if(context.select<AuthenticationCubit, List<String>>((value) => value.state.user!.eventSigns!).contains(uuid) || eventProcess != "참여하기") {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                title: "이미 참가하셨거나 /\n 참가기간이 아닙니다.",
                fontSize: 23.0,
              ),
              SizedBox(height: 10.0),
              Icon(Icons.how_to_vote_outlined,
                color: Colors.redAccent,
                size: 50.0,
              )
            ],
          ),
        ),
      );
    }

    return Container();
  }
}
