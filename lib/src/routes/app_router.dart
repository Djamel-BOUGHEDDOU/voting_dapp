import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voting_dapp/src/injection/injection.dart';
import '../presentation/pages/voting_page.dart';
import '../presentation/blocs/voting_bloc.dart';
import '../presentation/blocs/voting_events.dart';
import '../domain/usecases/voting_usecases.dart';
import '../domain/repositories/voting_repository.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          // Provide repository and bloc at route level
          return RepositoryProvider.value(
            value: sl<VotingRepository>(),
            child: BlocProvider(
              create: (_) => VotingBloc(
                getProposalsUsecase: sl<GetProposalsUsecase>(),
                castVoteUsecase: sl<CastVoteUsecase>(),
              )..add(LoadProposals()),
              child: const VotingPage(),
            ),
          );
        },
      ),
    ],
  );
}
