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
    const pancakeswapRouter = "0x10ED43C718714eb63d5aA57B78B54704E256024E"; // pancakeswap router
    // const TOR = "0x1d6cbdc6b29c6afbae65444a1f65ba9252b8ca83";
    // const TorPriceFeed_Implementation = await deploy("TWAPPriceFeed", {
    //   from: deployer,
    //   args: [TOR, USDT, pancakeswapRouter],
    //   log: true,
    // });
    // const HAY = "0x0782b6d8c4551B9760e74c0545a9bCD90bdc41E5";
    // const TorPriceFeed_Implementation = await deploy("TWAPPriceFeed", {
    //   from: deployer,
    //   args: [HAY, USDT, pancakeswapRouter],
    //   log: true,
    // });
    // const WOM = "0xAD6742A35fB341A9Cc6ad674738Dd8da98b94Fb1";
    // const WomPriceFeed_Implementation = await deploy("TWAPPriceFeed", {
    //   from: deployer,
    //   args: [WOM, USDT, pancakeswapRouter],
    //   log: true,
    // });

    // const USTC = "0x23396cF899Ca06c4472205fC903bDB4de249D6fC";
    // const USTCPriceFeed_Implementation = await deploy("TWAPPriceFeed", {
    //   from: deployer,
    //   args: [USTC, USDT, pancakeswapRouter],
    //   log: true,
    // });
    const BTT = "0x352Cb5E19b12FC216548a2677bD0fce83BaE434B";
    const BTTPriceFeed_Implementation = await deploy("TWAPPriceFeed", {
      from: deployer,
      args: [BTT, USDT, pancakeswapRouter],
      log: true,
    });
    
  }
  else if(network.name === "okex"){
    const WOKT = "0x8f8526dbfd6e38e3d8307702ca8469bae6c56c15";
    const USDT = "0x382bb369d343125bfb2117af9c149795c6c65c50";
    const factory = "0x709102921812B3276A65092Fe79eDfc76c4D4AFe"; // cherryswap factory
    const okse = "0xA844C05ae51DdafA6c4d5c801DE1Ef5E6F626bEC";  // OKSE 
    const router = "0x865bfde337C8aFBffF144Ff4C29f9404EBb22b15";
    const WOKTPriceFeed_Implementation = await deploy("TWAPPriceFeed", {
      from: deployer,
      args: [WOKT, USDT, router],
      log: true,
    });
    const USDCPriceFeed_Implementation = await deploy("TWAPPriceFeed", {
      from: deployer,
      args: [USDT, USDT, router],
      log: true,
    });
   
  }
};
export default func;
func.tags = ["TWAPPriceFeed"];
