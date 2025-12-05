const Ballot = artifacts.require("Ballot");
const { expect } = require('chai');

contract("Ballot", accounts => {
  const [chair, voter1, voter2] = accounts;

  beforeEach(async function() {
    this.ballot = await Ballot.new(["Djamel", "Amine"], { from: chair });
  });

  it("should have 2 proposals", async function() {
    const count = await this.ballot.proposalsCount();
    expect(count.toNumber()).to.equal(2);
  });

  it("should allow voting and increase vote count", async function() {
    await this.ballot.vote(0, { from: voter1 });
    const p = await this.ballot.getProposal(0);
    expect(p.voteCount.toNumber()).to.equal(1);
  });

  it("should prevent double voting", async function() {
    await this.ballot.vote(0, { from: voter1 });
    await expect(this.ballot.vote(1, { from: voter1 })).to.be.rejected;
  });
});
