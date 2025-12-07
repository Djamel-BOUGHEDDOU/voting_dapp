import 'package:voting_dapp/src/data/datasources/blockchain_remote_data_source.dart';
import 'package:voting_dapp/src/domain/entities/proposal.dart';
import 'package:voting_dapp/src/domain/repositories/voting_repository.dart';

class VotingRepositoryImpl implements VotingRepository {
  final BlockchainRemoteDataSource remoteDataSource;

  VotingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<int> getProposalsCount() async {
    return await remoteDataSource.getProposalsCount();
  }

  @override
  Future<List<Proposal>> getAllProposals() async {
    final proposalModelList = await remoteDataSource.getAllProposals();
    return proposalModelList
        .map((proposalModel) => proposalModel.toEntity())
        .toList();
  }

  @override
  Future<String> castVote(int proposalId, {required String fromAddress}) async {
    return await remoteDataSource.castVote(
      proposalId,
      fromAddress: fromAddress,
    );
  }
}
