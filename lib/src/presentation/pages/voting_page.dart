import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voting_dapp/src/presentation/widgets/private_key_sheet.dart';
import 'package:voting_dapp/src/presentation/widgets/proposal_title.dart';
import 'package:voting_dapp/src/presentation/widgets/tx_header.dart';
import '../blocs/voting_bloc.dart';
import '../blocs/voting_events.dart';
import '../blocs/voting_state.dart';

class VotingPage extends StatelessWidget {
  const VotingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voting dApp'), centerTitle: true),
      body: BlocListener<VotingBloc, VotingState>(
        listenWhen: (prev, cur) =>
            prev.message != cur.message || prev.status != cur.status,
        listener: (context, state) {
          if (state.message.isNotEmpty) {
            final color = state.status == VotingStatus.error
                ? Colors.red
                : Colors.green;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: color),
            );
          }
        },
        child: SafeArea(
          child: BlocBuilder<VotingBloc, VotingState>(
            builder: (context, state) {
              if (state.status == VotingStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == VotingStatus.txPending) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 8),
                      Text('Broadcasting transaction...'),
                    ],
                  ),
                );
              }

              final proposals = state.proposals;
              if (proposals.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.how_to_vote_outlined,
                        size: 72,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.status == VotingStatus.error
                            ? 'Failed to load proposals'
                            : 'No proposals found',
                      ),
                      if (state.status == VotingStatus.error)
                        const SizedBox(height: 8),
                      if (state.status == VotingStatus.error)
                        ElevatedButton(
                          onPressed: () =>
                              context.read<VotingBloc>().add(LoadProposals()),
                          child: const Text('Retry'),
                        ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async =>
                    context.read<VotingBloc>().add(LoadProposals()),
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: proposals.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    if (index == 0) return TxHeader(txHash: state.txHash);
                    final proposal = proposals[index - 1];
                    return ProposalTile(
                      proposal: proposal,
                      onVote: () => showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        builder: (ctx) => PrivateKeySheet(
                          onSubmit: (privateKeyHex) {
                            Navigator.of(ctx).pop();
                            context.read<VotingBloc>().add(
                              VoteRequested(
                                proposalId: proposal.id,
                                fromPrivateKey: privateKeyHex.trim(),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
