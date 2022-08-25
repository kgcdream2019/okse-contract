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
  else if(network.name === "bscmainnet"){
    const USDT = "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56"; // BUSD
    const pancakeswapRouter = "0x10ED43C718714eb63d5aA57B78B54704E256024E"; // spookyswap router
    // const TOR = "0x1d6cbdc6b29c6afbae65444a1f65ba9252b8ca83";
    // const TorPriceFeed_Implementation = await deploy("TWAPPriceFeed", {
    //   from: deployer,
    //   args: [TOR, USDT, pancakeswapRouter],
    //   log: true,
    // });
    const HAY = "0x0782b6d8c4551B9760e74c0545a9bCD90bdc41E5";
    const TorPriceFeed_Implementation = await deploy("TWAPPriceFeed", {
      from: deployer,
      args: [HAY, USDT, pancakeswapRouter],
      log: true,
    });
    
  }
};
export default func;
func.tags = ["TWAPPriceFeed"];
