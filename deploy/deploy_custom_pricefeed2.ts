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
    const MAI = "0xfb98b335551a418cd0737375a2ea0ded62ea213b";
    const WETH = "0x21be370d5312f44cb42ce377bc9b8a0cef1a4c83";
    const TOR = "0x74E23dF9110Aa9eA0b6ff2fAEE01e740CA1c642e";
    // const OksePriceFeed_Implementation = await deploy('CustomPriceFeed2', {
    //   from: deployer,
    //   args: [okse, USDT, WETH, spookyRouter],
    //   log: true,
    // })
    // const BooPriceFeed_Implementation = await deploy('CustomPriceFeed2', {
    //   from: deployer,
    //   args: [BOO, USDT, WETH, spookyRouter],
    //   log: true,
    // })
    // const MaiPriceFeed_Implementation = await deploy('CustomPriceFeed2', {
    //   from: deployer,
    //   args: [MAI, USDT, WETH, spookyRouter],
    //   log: true,
    // })
    // const TOMB = "0x6c021Ae822BEa943b2E66552bDe1D2696a53fbB7";
    // const TombPriceFeed_Implementation = await deploy('CustomPriceFeed2', {
    //   from: deployer,
    //   args: [TOMB, USDT, WETH, spookyRouter],
    //   log: true,
    // })

    const TORPriceFeed_Implementation = await deploy("CustomPriceFeed2", {
      from: deployer,
      args: [TOR, USDT, WETH, spookyRouter],
      log: true,
    });
  }
  if (network.name === "bscmainnet") {
  }
};
export default func;
func.tags = ["CustomPriceFeed2"];
