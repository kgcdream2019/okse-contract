var OkseCardPriceOracle = artifacts.require("./OkseCardPriceOracle.sol")
var Converter = artifacts.require("./Converter.sol")
module.exports = function(deployer) {
  deployer.deploy(OkseCardPriceOracle);
  deployer.deploy(Converter);

};