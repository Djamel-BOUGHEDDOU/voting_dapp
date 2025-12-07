// lib/src/presentation/blocs/voting_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/proposal.dart';

enum VotingStatus { initial, loading, loaded, txPending, txSuccess, error }

class VotingState extends Equatable {
  final VotingStatus status;
  final List<Proposal> proposals;
  final String message;
  final String txHash;

  const VotingState({
    this.status = VotingStatus.initial,
    this.proposals = const [],
    this.message = '',
    this.txHash = '',
  });

  // CopyWith method for immutability
  VotingState copyWith({
    VotingStatus? status,
    List<Proposal>? proposals,
    String? message,
    String? txHash,
  }) {
    return VotingState(
      status: status ?? this.status,
      proposals: proposals ?? this.proposals,
      message: message ?? this.message,
      txHash: txHash ?? this.txHash,
    );
  }

  bool get hasProposals => proposals.isNotEmpty;

  @override
  List<Object?> get props => [status, proposals, message, txHash];
}
