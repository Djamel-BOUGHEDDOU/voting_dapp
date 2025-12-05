// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Ballot {
    struct Proposal {
        string name;
        uint256 voteCount;
    }

    address public chairperson;
    mapping(address => bool) public voted;
    Proposal[] public proposals;

    event Voted(address indexed voter, uint indexed proposal);

    constructor(string[] memory names) public {
        chairperson = msg.sender;
        for (uint i = 0; i < names.length; i++) {
            proposals.push(Proposal({name: names[i], voteCount: 0}));
        }
    }

    function vote(uint proposal) external {
        require(!voted[msg.sender], "already voted");
        require(proposal < proposals.length, "invalid proposal");
        voted[msg.sender] = true;
        proposals[proposal].voteCount += 1;
        emit Voted(msg.sender, proposal);
    }

    function proposalsCount() external view returns (uint) {
        return proposals.length;
    }

    function getProposal(
        uint i
    ) external view returns (string memory name, uint256 voteCount) {
        Proposal storage p = proposals[i];
        return (p.name, p.voteCount);
    }
}
