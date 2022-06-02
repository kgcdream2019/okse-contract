import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts, network } = hre;
  const { deploy } = deployments;
  // console.log(network);
  const { deployer } = await getNamedAccounts();

  // const oksecardPriceOracle = await deploy('OkseCardPriceOracle', {
  //   from: deployer,
  //   args: [],
  //   log: true,
  // })
  // address _WETH, address _USDT, address _okseAddress, address _priceOracle, address _factory
  var _WETH: string; // WMATIC
  var USDT: string; // USDC
  var okse: string; // OKSE
  var factory: string; // sushiswap factory
  if (network.name === "fantom") {
    _WETH = "0x21be370D5312f44cB42ce377BC9b8a0cEF1A4C83"; // WMATIC
    USDT = "0x04068DA6C83AFCFA0e13ba15A6696662335D5B75"; // USDC
    okse = "0xEFF6FcfBc2383857Dd66ddf57effFC00d58b7d9D"; // OKSE
    factory = "0xc35DADB65012eC5796536bD9864eD8773aBc74C4"; // sushiswap factory
  }
  if (network.name === "bscmainnet") {
    _WETH = "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c"; // WBNB
    USDT = "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56"; // BUSD
    okse = "0x5A41F637C3f7553dBa6dDC2D3cA92641096577ea"; // OKSE / SPIRIT
    factory = "0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73"; // pancakeswap factory
  }
  const signer = "0x5126EA3894671E1c6cce47D3fB462E3C270e499e";

  /////////bsc network//////////////////////////////////////////////////////////////////////////
  // address _WETH, address _USDT, address _okseAddress, address _priceOracle, address _factory

  // // const oksecard = await deploy('OkseCard', {
  // //     from: deployer,
  // //     args: [_WETH, USDT, okse],
  // //     libraries: {

  // //     },
  // //     proxy: {
  // //       owner: deployer,
  // //       proxyContract: 'OpenZeppelinTransparentProxy',
  // //       viaAdminContract: 'DefaultProxyAdmin',
  // //     },
  // //     log: true,
  // //   })
  // //   console.log("oksecard address = ", oksecard.address);

  // const DefaultProxyAdmin = await deploy('ProxyAdmin', {
  //   from: deployer,
  //   args: [],
  //   log: true,
  // })

  const OkseCard_Implementation = await deploy('OkseCardV2', {
    from: deployer,
    args: [_WETH, USDT, okse, signer],
    log: true,
  })
  // // const SpookySwapper = await deploy('SpookySwapper', {
  // //   from: deployer,
  // //   args: [spookyFactory],
  // //   log: true,
  // // })
  // // const SushiSwapper = await deploy('SushiSwapper', {
  // //   from: deployer,
  // //   args: [factory],
  // //   log: true,
  // // })
  // const PancakeSwapper = await deploy('PancakeSwapper', {
  //   from: deployer,
  //   args: [factory],
  //   log: true,
  // })

  // // const QuickSwapper = await deploy('QuickSwapper', {
  // //   from: deployer,
  // //   args: [factory],
  // //   log: true,
  // // })
  // const OkseCard_Proxy = await deploy('TransparentUpgradeableProxy',{
  //   from: deployer,
  //   args: [OkseCard_Implementation.address, DefaultProxyAdmin.address,'0x'],
  //   log: true,
  // })
  // // console.log("OkseCard_Proxy = ", OkseCard_Proxy.address);
};
export default func;
func.tags = ["OkseCard"];
