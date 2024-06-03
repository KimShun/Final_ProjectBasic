import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

class EventModelResult extends Equatable {
  final List<EventModel>? items;
  const EventModelResult({this.items});

  EventModelResult.init() : this(items: const []);

  EventModelResult copyWithFromList(List<EventModel> eventModels) {
    return EventModelResult(items: List.of(items ?? [])..addAll(eventModels));
  }

  @override
  // TODO: implement props
  List<Object?> get props => [items];
}

@JsonSerializable()
class EventModel extends Equatable {
  final String? uuid;
  final String? eventImage;
  final String? title;
  final String? content;
  final DateTime? date;
  final String? eventProgress;
  final bool? userImageAvailable;
  final List<Map<String, dynamic>>? userEventSign;

  const EventModel({
    this.uuid,
    this.eventImage,
    this.title,
    this.content,
    this.date,
    this.eventProgress,
    this.userImageAvailable,
    this.userEventSign,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
  Map<String, dynamic> toJson() => _$EventModelToJson(this);

  EventModel copyWith({
    String? uuid,
    String? eventImage,
    String? title,
    String? content,
    DateTime? date,
    String? eventProgress,
    bool? userImageAvailable,
    List<Map<String, dynamic>>? userEventSign,
  }) {
    return EventModel(
      uuid: uuid ?? this.uuid,
      eventImage: eventImage ?? this.eventImage,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      eventProgress: eventProgress ?? this.eventProgress,
      userImageAvailable: userImageAvailable ?? this.userImageAvailable,
      userEventSign: userEventSign ?? this.userEventSign,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [uuid, eventImage, title, content, date, eventProgress, userImageAvailable, userEventSign];
}
