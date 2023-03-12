const Lottery = artifacts.require("/.Lottery.sol");
module.exports = function (deployer) {
    deployer.deployer(Lottery);
}