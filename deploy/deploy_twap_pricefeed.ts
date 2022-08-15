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
    const spookyRouter = "0xF491e7B69E4244ad4002BC14e878a34207E38c29"; // spookyswap router
    const MAI = "0xfb98b335551a418cd0737375a2ea0ded62ea213b";
    const MaiPriceFeed_Implementation = await deploy("TWAPPriceFeed", {
      from: deployer,
      args: [MAI, USDT, spookyRouter],
      log: true,
    });

  }
};
export default func;
func.tags = ["TWAPPriceFeed"];
