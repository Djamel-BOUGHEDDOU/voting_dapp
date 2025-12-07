import 'package:bloc/bloc.dart';
import 'package:voting_dapp/src/domain/usecases/voting_usecases.dart';
import 'package:voting_dapp/src/presentation/blocs/voting_events.dart';
import 'package:voting_dapp/src/presentation/blocs/voting_state.dart';

class VotingBloc extends Bloc<VotingEvents, VotingState> {
  final GetProposalsUsecase getProposalsUsecase;
  final CastVoteUsecase castVoteUsecase;

  VotingBloc({required this.getProposalsUsecase, required this.castVoteUsecase})
    : super(const VotingState()) {
    // Event handler for loading proposals
    on<LoadProposals>(_onLoadProposals);

    // Event handler for casting a vote
    on<VoteRequested>(_onVoteRequested);
  }

  // -------------------- HANDLERS --------------------

  Future<void> _onLoadProposals(
    LoadProposals event,
    Emitter<VotingState> emit,
  ) async {
    emit(state.copyWith(status: VotingStatus.loading, message: ''));

    try {
      final proposals = await getProposalsUsecase.call();
      emit(state.copyWith(status: VotingStatus.loaded, proposals: proposals));
    } catch (e) {
      emit(
        state.copyWith(
          status: VotingStatus.error,
          message: 'Failed to load proposals: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onVoteRequested(
    VoteRequested event,
    Emitter<VotingState> emit,
  ) async {
    emit(state.copyWith(status: VotingStatus.txPending, message: ''));

    try {
      final txHash = await castVoteUsecase.call(
        event.proposalId,
        fromAddress: event.fromPrivateKey,
      );

      emit(
        state.copyWith(
          status: VotingStatus.txSuccess,
          txHash: txHash,
          message: 'Vote cast successfully!',
        ),
      );

      // Optionally refresh proposals after voting
      add(LoadProposals());
    } catch (e) {
      emit(
        state.copyWith(
          status: VotingStatus.error,
          message: 'Failed to cast vote: ${e.toString()}',
        ),
      );
    }
  }
}
