import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class SaleDropGroupCubit extends Cubit<SaleDropGroupState> {
  SaleDropGroupCubit() : super(SaleDropGroupState(dropItems: dropItems, groupItems: groupItems));

  void changeDropSelected(String? value) {
    emit(state.copyWith(dropSelected: value));
  }

  void changeGroupSelected(int index) {
    emit(state.copyWith(groupSelected: state.groupItems![index]));
  }
}

class SaleDropGroupState extends Equatable {
  final List<String>? dropItems;
  final List<String>? groupItems;
  final String? dropSelected;
  final String groupSelected;

  const SaleDropGroupState({
    this.dropItems,
    this.groupItems,
    this.dropSelected,
    this.groupSelected = "전체",
  });

  SaleDropGroupState copyWith({
    List<String>? dropItems,
    List<String>? groupItems,
    String? dropSelected,
    String? groupSelected,
  }) {
    return SaleDropGroupState(
      dropItems: dropItems ?? this.dropItems,
      groupItems: groupItems ?? this.groupItems,
      dropSelected: dropSelected ?? this.dropSelected,
      groupSelected: groupSelected ?? this.groupSelected,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [dropItems, groupItems, dropSelected, groupSelected];
}

final List<String> dropItems = [
  '강아지',
  '고양이',
  '토끼',
  '기니피그',
  '도마뱀',
  '기타',
];

final List<String> groupItems = [
  "전체",
  "세일",
  "의류",
  "사료",
  "간식",
  "장난감",
  "미용",
  "기타"
];