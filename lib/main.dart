import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voting_dapp/src/bootstrap.dart';
import 'package:voting_dapp/src/presentation/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // create the router with all DI - change network/contract in bootstrap.dart
  final GoRouter router = await createAppRouter();

  runApp(MyApp(router: router));
}
