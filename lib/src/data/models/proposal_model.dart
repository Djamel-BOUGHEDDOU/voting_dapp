import 'package:voting_dapp/src/domain/entities/proposal.dart';

class ProposalModel extends Proposal {
  ProposalModel({required super.id, required super.name, required super.votes});

  factory ProposalModel.fromMap(Map<String, dynamic> map) {
    return ProposalModel(id: map['id'], name: map['name'], votes: map['votes']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'votes': votes};
  }

  Proposal toEntity() {
    return Proposal(id: id, name: name, votes: votes);
  }
}
