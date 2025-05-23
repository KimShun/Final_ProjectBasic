import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shopping_minna_pet/src/auth/cubit/signup_cubit.dart';
import 'package:shopping_minna_pet/src/common/component/api_key.dart';
import 'package:shopping_minna_pet/src/common/component/color.dart';
import 'package:shopping_minna_pet/src/common/cubit/authentication_cubit.dart';
import 'package:shopping_minna_pet/src/common/cubit/navigation_cubit.dart';
import 'package:shopping_minna_pet/src/common/cubit/upload_cubit.dart';
import 'package:shopping_minna_pet/src/common/model/event_model.dart';
import 'package:shopping_minna_pet/src/common/model/post_model.dart';
import 'package:shopping_minna_pet/src/common/model/user_model.dart';
import 'package:shopping_minna_pet/src/common/repository/authentication_repository.dart';
import 'package:shopping_minna_pet/src/common/repository/event_repository.dart';
import 'package:shopping_minna_pet/src/common/repository/post_repository.dart';
import 'package:shopping_minna_pet/src/common/repository/user_repository.dart';
import 'package:shopping_minna_pet/src/event/event.dart';
import 'package:shopping_minna_pet/src/event/cubit/event_cubit.dart';
import 'package:shopping_minna_pet/src/event/write_event.dart';
import 'package:shopping_minna_pet/src/event/event_detail.dart';
import 'package:shopping_minna_pet/src/post/cubit/post_cubit.dart';
import 'package:shopping_minna_pet/src/post/post_detail.dart';
import 'package:shopping_minna_pet/src/post/write_post.dart';
import 'package:shopping_minna_pet/src/profile/ProfileScreen.dart';
import 'package:shopping_minna_pet/src/profile/cubit/modify_profile_cubit.dart';
import 'package:shopping_minna_pet/src/profile/modify_profile.dart';
import 'package:shopping_minna_pet/src/profile/my_liked_post.dart';
import 'package:shopping_minna_pet/src/profile/my_written_post.dart';
import 'package:shopping_minna_pet/src/sale/SaleScreen.dart';
import 'package:shopping_minna_pet/src/sale/SaleScreen_detail.dart';
import 'package:shopping_minna_pet/src/sale/cubit/sale_drop_and_group_cubit.dart';
import 'package:shopping_minna_pet/src/shoppingbasket/BasketScreen.dart';
import 'firebase_options.dart';

import 'src/home.dart';
import 'src/auth/login.dart';
import 'src/auth/signup.dart';
import 'src/post/post.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // flutter splash setting
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // flutter firebase setting
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // hydrated bloc setting
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  // flutter kakaosdk setting
  KakaoSdk.init(
    nativeAppKey: kakao_native_key,
    javaScriptAppKey: kakao_javascript_key
  );

  await Future.delayed(const Duration(milliseconds: 1000));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var db = FirebaseFirestore.instance;
    var storage = FirebaseStorage.instance;

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthenticationRepository(FirebaseAuth.instance, null, null, null)),
        RepositoryProvider(create: (context) => UserRepository(db)),
        RepositoryProvider(create: (context) => PostRepository(db)),
        RepositoryProvider(create: (context) => EventRepository(db))
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthenticationCubit(context.read<AuthenticationRepository>(), context.read<UserRepository>())),
          BlocProvider(create: (context) => SignUpCubit(context.read<AuthenticationCubit>().state.user!, context.read<UserRepository>())),
          BlocProvider(create: (context) => UploadCubit(storage)),
          BlocProvider(create: (context) => PostCubit(context.read<AuthenticationCubit>().state.user!, context.read<PostRepository>())),
          BlocProvider(create: (context) => NavigationCubit()),
          BlocProvider(create: (context) => EventCubit(context.read<AuthenticationCubit>().state.user!, context.read<EventRepository>(), context.read<UserRepository>())),
          BlocProvider(create: (context) => SaleDropGroupCubit()),
          BlocProvider(create: (context) => ModifyProfileCubit(context.read<AuthenticationCubit>().state.user!, context.read<UserRepository>()))
        ],
        child: MaterialApp.router(
          theme: ThemeData(
            scaffoldBackgroundColor: BG_COLOR,
            appBarTheme: AppBarTheme(
              backgroundColor: BG_COLOR,
            )
          ),
          routerConfig: _router,
        ),
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/posts',
      builder: (context, state) => const PostScreen(),
    ),
    GoRoute(
      path: '/writePost',
      builder: (context, state) => const WritePostScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/events',
      builder: (context, state) => const EventPageScreen(),
    ),
    GoRoute(
      path: '/writeEvent',
      builder: (context, state) => const WriteEventScreen(),
    ),
    GoRoute(
      path: '/sale',
      builder: (context, state) => const SaleScreen(),
    ),
    GoRoute(
      path: '/saledetail',
      builder: (context, state) => const SaleDetailScreen(),
    ),
    GoRoute(
      path: '/modifyProfile',
      builder: (context, state) => const ModifyProfileScreen(),
    ),
    GoRoute(
      path: '/myLikePosts',
      builder: (context, state) => const MyLikedPostsScreen()
    ),
    GoRoute(
      path: '/myWrittenPosts',
      builder: (context, state) => MyWrittenPostsScreen(userModel: state.extra as UserModel),
    ),
    GoRoute(
      path: '/eventdetail',
      builder: (context, state) => EventDetailScreen(eventModel: state.extra as EventModel),
    ),
    GoRoute(
      path: '/basket',
      builder: (context, state) => const BasketScreen(),
    ),
    GoRoute(
      path: '/postdetail',
      builder: (context, state) => PostDetailScreen(postModel: state.extra as PostModel),
    )
  ]
);
