abstract class VotingEvents {}

class LoadProposals extends VotingEvents {}

class VoteRequested extends VotingEvents {
  final int proposalId;
  final String fromPrivateKey;

  VoteRequested({required this.proposalId, required this.fromPrivateKey});
}
