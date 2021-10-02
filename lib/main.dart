import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Riverpod #756',
      home: SplashPage(title: 'Riverpod #756'),
    );
  }
}

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ProviderListener<AuthState>(
        onChange: (_, value) {
          // here I generally naviagate to another page
          // after determining auth state
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You are ${describeEnum(value)}'),
            ),
          );
        },
        provider: myProvider,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

enum AuthState { unknown, authenticated, unauthenticated }

final myProvider = StateNotifierProvider<MyProvider, AuthState>(
    (ref) => MyProvider(AuthState.unknown));

class MyProvider extends StateNotifier<AuthState> {
  MyProvider(state) : super(state) {
    checkAuthState();
  }

  Future<void> checkAuthState() async {
    // this is my some logic to check auth state which does not a future
    final randomNumberGenerator = Random();
    final randomBoolean = randomNumberGenerator.nextBool();

    // without this state change is not notified by notify listeners
    // TODO uncomment and comment to try difference
    // await Future.delayed(const Duration(milliseconds: 100));

    if (randomBoolean) {
      state = AuthState.authenticated;
    } else {
      state = AuthState.unauthenticated;
    }
  }
}
