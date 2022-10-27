import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts, network } = hre;
  const { deploy } = deployments;

  const { deployer } = await getNamedAccounts();

  /////////fantom network//////////////////////////////////////////////////////////////////////////
  if (network.name === "fantom") {
    // address _WETH, address _USDT, address _okseAddress, address _priceOracle, address _factory
    const USDT = "0x04068DA6C83AFCFA0e13ba15A6696662335D5B75"; // USDC
    const okse = "0x3b53D2C7B44d40BE05Fa5E2309FFeB6eB2492d88"; // OKSE
    const spookyRouter = "0xF491e7B69E4244ad4002BC14e878a34207E38c29"; // spookyswap router
    const BOO = "0x841fad6eae12c286d1fd18d1d525dffa75c7effe";
    const WETH = "0x21be370d5312f44cb42ce377bc9b8a0cef1a4c83";
    const TOR = "0x74E23dF9110Aa9eA0b6ff2fAEE01e740CA1c642e";
    const JulD = "0xeff6fcfbc2383857dd66ddf57efffc00d58b7d9d";
    const TOMB = "0x6c021Ae822BEa943b2E66552bDe1D2696a53fbB7";
    const OksePriceFeed_Implementation = await deploy("TWAPPriceFeed2", {
      from: deployer,
      args: [okse, USDT, WETH, spookyRouter],
      log: true,
    });
    const TORPriceFeed_Implementation = await deploy("TWAPPriceFeed2", {
      from: deployer,
      args: [TOR, USDT, WETH, spookyRouter],
      log: true,
    });
    const JulDPriceFeed_Implementation = await deploy("TWAPPriceFeed2", {
      from: deployer,
      args: [JulD, USDT, WETH, spookyRouter],
      log: true,
    });
    const BooPriceFeed_Implementation = await deploy("TWAPPriceFeed2", {
      from: deployer,
      args: [BOO, USDT, WETH, spookyRouter],
      log: true,
    });

    const TombPriceFeed_Implementation = await deploy("TWAPPriceFeed2", {
      from: deployer,
      args: [TOMB, USDT, WETH, spookyRouter],
      log: true,
    });
  }
  if (network.name === "bscmainnet") {
    const USDT = "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56"; // BUSD
    // const okse = "0x606FB7969fC1b5CAd58e64b12Cf827FB65eE4875"; // OKSE
    const WETH = "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c";
    const pancakeRouter = "0x10ED43C718714eb63d5aA57B78B54704E256024E"; // pancakeswap router

    // const OksePriceFeed_Implementation = await deploy("TWAPPriceFeed2", {
    //   from: deployer,
    //   args: [okse, USDT, WETH, pancakeRouter],
    //   log: true,
    // });

    // const SHIB = "0x2859e4544C4bB03966803b044A93563Bd2D0DD4D"; // SHIB
    // const SHIBPriceFeed_Implementation = await deploy("TWAPPriceFeed2", {
    //   from: deployer,
    //   args: [SHIB, USDT, WETH, pancakeRouter],
    //   log: true,
    // });
    // const VOLT = "0x7db5af2B9624e1b3B4Bb69D6DeBd9aD1016A58Ac"; // VOLT
    // const VOLTPriceFeed_Implementation = await deploy("TWAPPriceFeed2", {
    //   from: deployer,
    //   args: [VOLT, USDT, WETH, pancakeRouter],
    //   log: true,
    // });
    // const ARV = "0x6679eB24F59dFe111864AEc72B443d1Da666B360"; // ARV
    // const ARVTPriceFeed_Implementation = await deploy("TWAPPriceFeed2", {
    //   from: deployer,
    //   args: [ARV, USDT, WETH, pancakeRouter],
    //   log: true,
    // });
    // const LUNA = "0x156ab3346823B651294766e23e6Cf87254d68962"; // LUNA
    // const LUNATPriceFeed_Implementation = await deploy("TWAPPriceFeed2", {
    //   from: deployer,
    //   args: [LUNA, USDT, WETH, pancakeRouter],
    //   log: true,
    // });
    // const DOGE = "0xbA2aE424d960c26247Dd6c32edC70B295c744C43"; // DOGE
    // const DOGETPriceFeed_Implementation = await deploy("TWAPPriceFeed2", {
    //   from: deployer,
    //   args: [DOGE, USDT, WETH, pancakeRouter],
    //   log: true,
    // });

    // const MCRT = "0x4b8285aB433D8f69CB48d5Ad62b415ed1a221e4f"; // MCRT
    // const MCRTTPriceFeed_Implementation = await deploy("TWAPPriceFeed2", {
    //   from: deployer,
    //   args: [MCRT, USDT, WETH, pancakeRouter],
    //   log: true,
    // });
    const TWT = "0x4b8285aB433D8f69CB48d5Ad62b415ed1a221e4f"; // TWT
    const TWTPriceFeed_Implementation = await deploy("TWAPPriceFeed2", {
      from: deployer,
      args: [TWT, USDT, WETH, pancakeRouter],
      log: true,
    });
  }
  if (network.name === "avaxc") {
    const USDT = "0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E"; // USDC
    const okse = "0xbc7B0223Dd16cbc679c0D04bA3F4530D76DFbA87"; // OKSE
    const router = "0x60ae616a2155ee3d9a68541ba4544862310933d4"; // JoeRouter2 router
    const WETH = "0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7";
    const OksePriceFeed_Implementation = await deploy("TWAPPriceFeed2", {
      from: deployer,
      args: [okse, USDT, WETH, router],
      log: true,
    });
  }
  if (network.name === "okex") {
    const USDT = "0x382bb369d343125bfb2117af9c149795c6c65c50";
    const okse = "0xA844C05ae51DdafA6c4d5c801DE1Ef5E6F626bEC"; // OKSE
    const router = "0x865bfde337C8aFBffF144Ff4C29f9404EBb22b15";
    const WOKT = "0x8f8526dbfd6e38e3d8307702ca8469bae6c56c15";

    const OksePriceFeed_Implementation = await deploy("TWAPPriceFeed2", {
      from: deployer,
      args: [okse, USDT, WOKT, router],
      log: true,
    });
  }
};
export default func;
func.tags = ["TWAPPriceFeed2"];
