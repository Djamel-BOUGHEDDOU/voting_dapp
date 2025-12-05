const Ballot = artifacts.require("Ballot");

module.exports = function (deployer) {
    const names = ["Djamel", "Amine", "Abdennour"];
    deployer.deploy(Ballot, names);
}