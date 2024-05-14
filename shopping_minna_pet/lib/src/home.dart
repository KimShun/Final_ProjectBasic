import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_minna_pet/src/common/component/app_text.dart';
import 'package:shopping_minna_pet/src/common/cubit/authentication_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
          return Column(
            children: [
              const AppText(title: "로그인 성공!", fontSize: 20.0, color: Colors.black,),
              Image.network(state.user!.profile!),
              AppText(title: "${state.user!.name!}", fontSize: 18.0, color: Colors.black,)
            ],
          );
        },
      ),
    );
  }
}