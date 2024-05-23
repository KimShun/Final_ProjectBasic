import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_minna_pet/src/common/component/app_loading_circular.dart';
import 'package:shopping_minna_pet/src/common/cubit/authentication_cubit.dart';

class ProfileScreen extends StatelessWidget {
  /// Constructs a [DetailsScreen]
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details Screen')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go back to the Home screen'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AuthenticationCubit>().logout();
                context.go("/login");
              },
              child: const Text('Logout!'),
            ),
          ],
        ),
      ),
    );
  }
}