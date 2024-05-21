import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState()) {
    emit(state.copyWith(selectedNum: SelectedTab.values.indexOf(state.selectedTab)));
  }

  void handleIndexChanged(int index, BuildContext context) {
    emit(state.copyWith(selectedTab: SelectedTab.values[index]));
    emit(state.copyWith(selectedNum: SelectedTab.values.indexOf(state.selectedTab)));
    changePage(context);
  }

  void changePage(BuildContext context) {
    if(state.selectedTab == SelectedTab.home) {
      context.go("/");
    }
    else if(state.selectedTab == SelectedTab.profile) {
      context.go("/profile");
    }
  }
}

enum SelectedTab {
  pets,
  search,
  home,
  shopping_cart,
  profile
}

class NavigationState extends Equatable {
  final SelectedTab selectedTab;
  final int? selectedNum;

  const NavigationState({
    this.selectedTab = SelectedTab.home,
    this.selectedNum,
  });

  NavigationState copyWith({
    SelectedTab? selectedTab,
    int? selectedNum
  }) {
    return NavigationState(
      selectedTab: selectedTab ?? this.selectedTab,
      selectedNum: selectedNum ?? this.selectedNum,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [selectedTab, selectedNum];
}