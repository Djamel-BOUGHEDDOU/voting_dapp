import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:voting_dapp/src/core/config.dart';
import 'package:voting_dapp/src/data/datasources/blockchain_remote_data_source.dart';
import 'package:voting_dapp/src/data/datasources/blockchain_remote_data_source_impl.dart';
import 'package:voting_dapp/src/data/repositories/voting_repository_impl.dart';
import 'package:voting_dapp/src/domain/repositories/voting_repository.dart';
import 'package:voting_dapp/src/domain/usecases/voting_usecases.dart';
import 'package:voting_dapp/src/presentation/blocs/voting_bloc.dart';
import 'package:web3dart/web3dart.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // External / core
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<Web3Client>(
    () => Web3Client(rpcUrl, sl<http.Client>()),
  );

  // Data sources
  sl.registerLazySingleton<BlockchainRemoteDataSource>(
    () => BlockchainRemoteDataSourceImpl(
      client: sl<Web3Client>(),
      abiPath: abiPath,
      contractAddress: contractAddress,
    ),
  );

  // Repositories
  sl.registerLazySingleton<VotingRepository>(
    () => VotingRepositoryImpl(
      remoteDataSource: sl<BlockchainRemoteDataSource>(),
    ),
  );

  // Usecases
  sl.registerLazySingleton(() => GetProposalsUsecase(sl<VotingRepository>()));
  sl.registerLazySingleton(() => CastVoteUsecase(sl<VotingRepository>()));

  // Blocs
  sl.registerFactory(
    () => VotingBloc(
      getProposalsUsecase: sl<GetProposalsUsecase>(),
      castVoteUsecase: sl<CastVoteUsecase>(),
    ),
  );
}
