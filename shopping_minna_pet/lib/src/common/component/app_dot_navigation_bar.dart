import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/navigation_cubit.dart';

class AppDotNavgationBar extends StatelessWidget {
  const AppDotNavgationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DotNavigationBar(
      itemPadding: const EdgeInsets.all(14),
      marginR: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      paddingR: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      currentIndex: context.select<NavigationCubit, int>((value) => value.state.selectedNum!),
      onTap: (index) {
        context.read<NavigationCubit>().handleIndexChanged(index, context);
      },
      // dotIndicatorColor: Colors.black,
      items: context.select<NavigationCubit, List<DotNavigationBarItem>>((value) => value.state.navigationItems!),
    );
  }
}
