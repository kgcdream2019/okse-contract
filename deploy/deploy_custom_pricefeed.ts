import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts, network } = hre;
  const { deploy } = deployments;

  const { deployer } = await getNamedAccounts();
  if (network.name === "fantom") {
    /////////fantom network//////////////////////////////////////////////////////////////////////////
    // address _WETH, address _USDT, address _okseAddress, address _priceOracle, address _factory
    const USDT = "0x04068DA6C83AFCFA0e13ba15A6696662335D5B75"; // USDC
    const okse = "0xEFF6FcfBc2383857Dd66ddf57effFC00d58b7d9D"; // OKSE
    const spookyRouter = "0xF491e7B69E4244ad4002BC14e878a34207E38c29"; // spookyswap router
    const BOO = "0x841fad6eae12c286d1fd18d1d525dffa75c7effe";
    const MAI = "0xfb98b335551a418cd0737375a2ea0ded62ea213b";

    // const OksePriceFeed_Implementation = await deploy('CustomPriceFeed', {
    //   from: deployer,
    //   args: [okse, USDT, spookyRouter],
    //   log: true,
    // })
    const BooPriceFeed_Implementation = await deploy("CustomPriceFeed", {
      from: deployer,
      args: [BOO, USDT, spookyRouter],
      log: true,
    });
    const MaiPriceFeed_Implementation = await deploy("CustomPriceFeed", {
      from: deployer,
      args: [MAI, USDT, spookyRouter],
      log: true,
    });
    const TAMB = "0x6c021Ae822BEa943b2E66552bDe1D2696a53fbB7";
    const TambPriceFeed_Implementation = await deploy("CustomPriceFeed", {
      from: deployer,
      args: [TAMB, USDT, spookyRouter],
      log: true,
    });
  }
};
export default func;
func.tags = ["CustomPriceFeed"];
