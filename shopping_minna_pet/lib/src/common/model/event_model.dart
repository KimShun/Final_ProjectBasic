import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

class EventModelResult extends Equatable {
  final List<EventModel>? items;
  const EventModelResult({
    this.items
  });

  EventModelResult.init() : this(items: const []);

  EventModelResult copyWithFromList(List<EventModel> eventModels) {
    return EventModelResult(
        items: List.of(items ?? [])..addAll(eventModels)
    );
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

  const EventModel({
    this.uuid,
    this.eventImage,
    this.title,
    this.content,
    this.date,
    this.eventProgress,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => _$EventModelFromJson(json);
  Map<String, dynamic> toJson() => _$EventModelToJson(this);

  EventModel copyWith({
    String? uuid,
    String? eventImage,
    String? title,
    String? content,
    DateTime? date,
    String? eventProgress,
  }) {
    return EventModel(
      uuid: uuid ?? this.uuid,
      eventImage: eventImage ?? this.eventImage,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      eventProgress: eventProgress ?? this.eventProgress,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [uuid, eventImage, title, content, date, eventProgress];
}