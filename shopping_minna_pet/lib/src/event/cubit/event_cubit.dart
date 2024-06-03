import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/model/event_model.dart';
import '../../common/model/user_model.dart';
import '../../common/repository/event_repository.dart';
import '../../common/repository/user_repository.dart';

class EventCubit extends Cubit<EventState> {
  final UserModel userModel;
  final EventRepository _eventRepository;
  final UserRepository _userRepository;

  EventCubit(this.userModel, this._eventRepository, this._userRepository) : super(EventState(
    signName: TextEditingController(text: userModel.name),
    signPetName: TextEditingController(text: userModel.petName),
    signResolve: TextEditingController(text: ""),
  )) {
    HomeBannerLoad();
  }

  void init() {
    emit(state.copyWith(events: EventModelResult.init()));
    loadEvents(10, true);
  }

  void changeSignName(String value) {
    state.signName!.text = value;
    state.signName!.selection = TextSelection.fromPosition(TextPosition(offset: state.signName!.text.length));
    emit(state.copyWith(signName: state.signName));
  }

  void changeSignPetName(String value) {
    state.signPetName!.text = value;
    state.signPetName!.selection = TextSelection.fromPosition(TextPosition(offset: state.signPetName!.text.length));
    emit(state.copyWith(signPetName: state.signPetName));
  }

  void changeSignResolve(String value) {
    state.signResolve!.text = value;
    state.signResolve!.selection = TextSelection.fromPosition(TextPosition(offset: state.signResolve!.text.length));
    emit(state.copyWith(signResolve: state.signResolve));
  }

  void HomeBannerLoad() async {
    emit(state.copyWith(status: EventStatus.loading));
    List<String>? imageList = await _eventRepository.loadEventsBannerList();
    emit(state.copyWith(
        imageBannerList: imageList, status: EventStatus.success));
  }

  void loadEvents(int limit, bool isInit) async {
    emit(state.copyWith(status: EventStatus.loading));
    List<EventModel>? eventModels =
        await _eventRepository.loadEvents(limit, isInit);

    if (eventModels != null) {
      emit(state.copyWith(
          events: state.events!.copyWithFromList(eventModels),
          status: EventStatus.success));
    } else {
      emit(state.copyWith(status: EventStatus.error));
    }
  }

  void changeImage(XFile? imageFile) {
    if (imageFile == null) {
      return;
    }

    var file = File(imageFile.path);
    emit(state.copyWith(eventImage: file));
  }

  void changeSignEventImage(XFile? imageFile) {
    if (imageFile == null) {
      return;
    }

    var file = File(imageFile.path);
    emit(state.copyWith(signEventImage: file));
  }

  void changeTitle(String title) {
    emit(state.copyWith(title: title));
  }

  void changeContent(String content) {
    emit(state.copyWith(content: content));
  }

  void changeDate(DateTime date) {
    emit(state.copyWith(date: date));
  }

  void changeUuid(String uuid) {
    emit(state.copyWith(uuid: uuid));
  }

  void changeMode(bool value) {
    emit(state.copyWith(mode: value));
  }

  void changeImageMode(bool value) {
    emit(state.copyWith(imageMode: value));
  }

  void uploadPercent(String percent) {
    emit(state.copyWith(percent: percent));
  }

  void updateImageEventBanner(String url) {
    emit(state.copyWith(
        eventModel: state.eventModel!.copyWith(eventImage: url),
        status: EventStatus.loading));
    submit();
  }

  void updateUserEventImage(String url) {
    emit(state.copyWith(
      eventModel: state.eventModel!.copyWith(
        userEventSign: [{
          "signName": state.signName!.text,
          "signPetName": state.signPetName!.text,
          "resolve": state.signResolve!.text,
          "userUid": userModel.uid,
          "imageUrl": url,
        }]
      ),
      status: EventStatus.loading,
    ));
    submit();
    userUpdateEvent();
  }

  void userEventSignSave(EventModel eventModel) {
    emit(state.copyWith(eventModel: eventModel));
    if (state.signName!.text == "" || state.signPetName!.text == "" || state.signResolve!.text == ""
        || (state.eventModel!.userImageAvailable! && state.signEventImage == null)) return;

    emit(state.copyWith(status: EventStatus.loading));

    EventModel newEvent = state.eventModel!.copyWith(
      userEventSign: [{
        "signName": state.signName!.text,
        "signPetName": state.signPetName!.text,
        "resolve": state.signResolve!.text,
        "userUid": userModel.uid,
      }],
    );

    emit(state.copyWith(eventModel: newEvent));

    if(state.eventModel!.userImageAvailable!) {
      emit(state.copyWith(status: EventStatus.uploading));
    } else {
      submit();
      userUpdateEvent();
    }
  }

  void save() {
    if (state.title == null ||
        state.title == "" ||
        state.content == null ||
        state.content == "" ||
        state.eventImage == null) return;
    emit(state.copyWith(status: EventStatus.loading));

    EventModel newEvent = EventModel(
      title: state.title,
      content: state.content,
      date: state.date,
      uuid: state.uuid,
      eventProgress: state.mode ? "투표하기" : "참여하기",
      userImageAvailable: state.imageMode,
    );
    emit(state.copyWith(eventModel: newEvent));

    if (state.eventImage != null) {
      emit(state.copyWith(status: EventStatus.uploading));
    } else {
      submit();
    }
  }

  void userUpdateEvent() async {
    var result = await _userRepository.updateEventSign(userModel, state.eventModel!.uuid!);

    if (result) {
      emit(state.copyWith(status: EventStatus.success));
    } else {
      emit(state.copyWith(status: EventStatus.error));
    }
  }

  void submit() async {
    var result = await _eventRepository.createEvent(state.eventModel!);

    if (result) {
      emit(state.copyWith(status: EventStatus.success));
    } else {
      emit(state.copyWith(status: EventStatus.error));
    }
  }
}

enum EventStatus { init, loading, success, uploading, error }

class EventState extends Equatable {
  final String? uuid;
  final File? eventImage;
  final String? title;
  final String? content;
  final DateTime? date;
  final EventStatus status;
  final EventModelResult? events;
  final bool mode;
  final bool imageMode;
  final EventModel? eventModel;
  final String? percent;
  final List<String>? imageBannerList;
  final TextEditingController? signName;
  final TextEditingController? signPetName;
  final TextEditingController? signResolve;
  final File? signEventImage;

  const EventState({
    this.uuid,
    this.eventImage,
    this.title,
    this.content,
    this.date,
    this.status = EventStatus.init,
    this.events,
    this.mode = false,
    this.imageMode = false,
    this.eventModel,
    this.percent,
    this.imageBannerList,
    this.signName,
    this.signPetName,
    this.signResolve,
    this.signEventImage,
  });

  EventState copyWith({
    String? uuid,
    File? eventImage,
    String? title,
    String? content,
    DateTime? date,
    EventStatus? status,
    EventModelResult? events,
    bool? mode,
    bool? imageMode,
    EventModel? eventModel,
    String? percent,
    List<String>? imageBannerList,
    TextEditingController? signName,
    TextEditingController? signPetName,
    TextEditingController? signResolve,
    File? signEventImage,
  }) {
    return EventState(
      uuid: uuid ?? this.uuid,
      eventImage: eventImage ?? this.eventImage,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      status: status ?? this.status,
      events: events ?? this.events,
      mode: mode ?? this.mode,
      imageMode: imageMode ?? this.imageMode,
      eventModel: eventModel ?? this.eventModel,
      percent: percent ?? this.percent,
      imageBannerList: imageBannerList ?? this.imageBannerList,
      signName: signName ?? this.signName,
      signPetName: signPetName ?? this.signPetName,
      signResolve: signResolve ?? this.signResolve,
      signEventImage: signEventImage ?? this.signEventImage,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [uuid, eventImage, title, content, status, date, events,
    mode, imageMode, eventModel, percent, imageBannerList, signName, signPetName, signResolve, signEventImage];
}
