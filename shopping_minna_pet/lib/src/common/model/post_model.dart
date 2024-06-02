import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shopping_minna_pet/src/common/model/user_model.dart';

part "post_model.g.dart";

class PostModelResult extends Equatable {
  final List<PostModel>? items;
  const PostModelResult({
     this.items,
  });

  PostModelResult.init() : this(items: const []);

  PostModelResult copyWithFromList(List<PostModel> postModels) {
    return PostModelResult(
      items: List.of(items ?? [])..addAll(postModels)
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [items];
}

@JsonSerializable()
class PostModel extends Equatable {
  final String? uuid;
  final String? writerUid;
  final List<String>? images;
  final String? title;
  final String? content;
  final DateTime? date;
  final int? likeCount;

  const PostModel({
    this.uuid,
    this.writerUid,
    this.images,
    this.title,
    this.content,
    this.date,
    this.likeCount,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  PostModel copyWith({
    String? uuid,
    List<String>? images,
    String? title,
    String? content,
    DateTime? date,
    String? writerUid,
    int? likeCount,
  }) {
    return PostModel(
      uuid: uuid ?? this.uuid,
      writerUid: writerUid ?? this.writerUid,
      images: images ?? this.images,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      likeCount: likeCount ?? this.likeCount,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [uuid, writerUid, images, title, content, date, likeCount];
}