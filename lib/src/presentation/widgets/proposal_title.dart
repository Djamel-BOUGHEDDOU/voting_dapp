import 'package:flutter/material.dart';
import '../../domain/entities/proposal.dart';

class ProposalTile extends StatelessWidget {
  final Proposal proposal;
  final VoidCallback onVote;

  const ProposalTile({required this.proposal, required this.onVote, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(proposal.name),
        subtitle: Text('Votes: ${proposal.votes}'),
        trailing: ElevatedButton(onPressed: onVote, child: const Text('Vote')),
      ),
    );
  }
}
