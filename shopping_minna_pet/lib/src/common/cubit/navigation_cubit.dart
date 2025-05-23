import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState()) {
    emit(state.copyWith(selectedNum: SelectedTab.values.indexOf(state.selectedTab)));
    emit(state.copyWith(navigationItems: navigationItems));
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
      context.push("/profile");
    }
    else if(state.selectedTab == SelectedTab.pets) {
      context.go("/sale");
    }
    else if(state.selectedTab == SelectedTab.pets) {
      context.push('/saledetail');
    }
    else if(state.selectedTab == SelectedTab.emoji_events) {
      context.push('/events');
    }
    else if(state.selectedTab == SelectedTab.shopping_cart) {
      context.push('/basket');
    }

    }
  }


enum SelectedTab {
  pets,
  emoji_events,
  home,
  shopping_cart,
  profile
}

List<DotNavigationBarItem> navigationItems = [
  DotNavigationBarItem(
    icon: const Icon(Icons.pets),
    selectedColor: Colors.brown,
  ),
  DotNavigationBarItem(
    icon: const Icon(Icons.emoji_events),
    selectedColor: Colors.orange,
  ),
  DotNavigationBarItem(
    icon: const Icon(Icons.home),
    selectedColor: Colors.purple,
  ),
  DotNavigationBarItem(
    icon: const Icon(Icons.shopping_cart),
    selectedColor: Colors.pink,
  ),
  DotNavigationBarItem(
    icon: const Icon(Icons.person),
    selectedColor: Colors.teal,
  ),
];

class NavigationState extends Equatable {
  final SelectedTab selectedTab;
  final int? selectedNum;
  final List<DotNavigationBarItem>? navigationItems;

  const NavigationState({
    this.selectedTab = SelectedTab.home,
    this.selectedNum,
    this.navigationItems,
  });

  NavigationState copyWith({
    SelectedTab? selectedTab,
    int? selectedNum,
    List<DotNavigationBarItem>? navigationItems,
  }) {
    return NavigationState(
      selectedTab: selectedTab ?? this.selectedTab,
      selectedNum: selectedNum ?? this.selectedNum,
      navigationItems: navigationItems ?? this.navigationItems,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [selectedTab, selectedNum, navigationItems];
}