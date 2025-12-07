import 'package:go_router/go_router.dart';
import 'package:voting_dapp/src/injection/injection.dart';
import 'package:voting_dapp/src/routes/app_router.dart';

Future<GoRouter> createAppRouter() async {
  await init();
  return createRouter();
}
