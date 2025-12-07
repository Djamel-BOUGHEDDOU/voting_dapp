import 'package:voting_dapp/src/domain/repositories/voting_repository.dart';
import 'package:voting_dapp/src/domain/entities/proposal.dart';

class GetProposalsUsecase {
  final VotingRepository repository;
  GetProposalsUsecase(this.repository);

  Future<List<Proposal>> call() async {
    return await repository.getAllProposals();
  }
}

class CastVoteUsecase {
  final VotingRepository repository;

  CastVoteUsecase(this.repository);

  Future<String> call(int proposalId, {required String fromAddress}) async {
    return await repository.castVote(proposalId, fromAddress: fromAddress);
  }
}
