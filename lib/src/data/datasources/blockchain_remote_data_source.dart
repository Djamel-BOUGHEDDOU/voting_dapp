import 'package:voting_dapp/src/data/models/proposal_model.dart';

abstract class BlockchainRemoteDataSource {
  Future<int> getProposalsCount();
  Future<List<ProposalModel>> getAllProposals();
  Future<String> castVote(int proposalId, {required String fromAddress});
}
