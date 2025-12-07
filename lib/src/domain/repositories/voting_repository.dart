import 'package:voting_dapp/src/domain/entities/proposal.dart';

abstract class VotingRepository {
  Future<int> getProposalsCount();
  Future<List<Proposal>> getAllProposals();
  Future<String> castVote(int proposalId, {required String fromAddress});
}
