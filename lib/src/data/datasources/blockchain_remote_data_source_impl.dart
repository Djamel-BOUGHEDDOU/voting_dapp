import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voting_dapp/src/data/datasources/blockchain_remote_data_source.dart';
import 'package:voting_dapp/src/data/models/proposal_model.dart';
import 'package:web3dart/web3dart.dart';

class BlockchainRemoteDataSourceImpl implements BlockchainRemoteDataSource {
  final Web3Client client;
  final String abiPath;
  final String contractAddress;
  late DeployedContract _contract;
  late ContractFunction _getProposalFn;
  late ContractFunction _proposalsCountFn;
  late ContractFunction _voteFn;
  bool _initialized = false;

  BlockchainRemoteDataSourceImpl({
    required this.client,
    required this.abiPath,
    required this.contractAddress,
  });

  Future<void> _init() async {
    if (_initialized) return;

    final abiString = await rootBundle.loadString(abiPath);
    final jsonAbi = jsonDecode(abiString);
    debugPrint(jsonAbi['abi'].toString());
    final abi = jsonEncode(jsonAbi['abi']);
    debugPrint(abi);
    _contract = DeployedContract(
      ContractAbi.fromJson(abi, 'Ballot'),
      EthereumAddress.fromHex(contractAddress),
    );

    _getProposalFn = _contract.function('getProposal');
    _proposalsCountFn = _contract.function('proposalsCount');
    _voteFn = _contract.function('vote');

    _initialized = true;
  }

  @override
  Future<String> castVote(int proposalId, {required String fromAddress}) async {
    await _init();

    final credentials = EthPrivateKey.fromHex(fromAddress);

    final txHash = await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: _contract,
        function: _voteFn,
        parameters: [BigInt.from(proposalId)],
      ),
      chainId: 1337,
    );

    return txHash;
  }

  @override
  Future<List<ProposalModel>> getAllProposals() async {
    await _init();
    final count = await getProposalsCount();

    final List<ProposalModel> proposals = [];
    for (var i = 0; i < count; i++) {
      final result = await client.call(
        contract: _contract,
        function: _getProposalFn,
        params: [BigInt.from(i)],
      );

      proposals.add(
        ProposalModel.fromMap({
          'id': i,
          'name': result[0] as String,
          'votes': (result[1] as BigInt).toInt(),
        }),
      );
    }
    return proposals;
  }

  @override
  Future<int> getProposalsCount() async {
    await _init();
    final result = await client.call(
      contract: _contract,
      function: _proposalsCountFn,
      params: [],
    );
    return (result[0] as BigInt).toInt();
  }
}
