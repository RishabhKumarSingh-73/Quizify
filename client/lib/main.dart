import 'package:client/core/constants.dart';
import 'package:client/core/widget/loader.dart';
import 'package:client/features/auth/models/usermodel.dart';
import 'package:client/features/auth/view/login_page.dart';
import 'package:client/features/auth/viewmodels/user_viewmodel.dart';
import 'package:client/features/quizify/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: SUPABASE_URL, anonKey: SUPABASE_ANON_KEY);
  final container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).checkSignedIn();
  final userState = container.read(authViewModelProvider);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MyApp(initialState: userState),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AsyncValue<UserModel>? initialState;
  const MyApp({super.key, this.initialState});

  @override
  Widget build(BuildContext context) {
    Widget? home;

    initialState?.when(
      data: (_) => home = HomePage(),
      error: (_, __) => home = SignInPage(),
      loading: () => home = const Loader(),
    );

    // Fallback if null
    home ??= SignInPage();

    return MaterialApp(debugShowCheckedModeBanner: false, home: home);
  }
}
