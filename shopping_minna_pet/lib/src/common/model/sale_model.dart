import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sale_model.g.dart';

class SaleModelResult extends Equatable {
  final List<SaleModel>? items;
  const SaleModelResult({
    this.items,
  });

  SaleModelResult.init() : this(items: const []);

  SaleModelResult copyWithFromList(List<SaleModel> saleModels) {
    return SaleModelResult(
        items: List.of(items ?? [])..addAll(saleModels)
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [items];
}

@JsonSerializable()
class SaleModel extends Equatable {
  final String? uuid;
  final String? title;
  final String? content;
  final List<String> saleImages;
  final String? type;

  const SaleModel({
    this.uuid,
    this.title,
    this.content,
    this.saleImages = const [],
    this.type,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) => _$SaleModelFromJson(json);
  Map<String, dynamic> toJson() => _$SaleModelToJson(this);

  SaleModel copyWith({
    String? uuid,
    String? title,
    String? content,
    List<String>? saleImages,
    String? type,
  }) {
    return SaleModel(
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      content: content ?? this.content,
      saleImages: saleImages ?? this.saleImages,
      type: type ?? this.type,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [uuid, title, content, saleImages, type];
}