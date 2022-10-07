import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction, DeployResult } from "hardhat-deploy/types";
const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts, network } = hre;
  const { deploy } = deployments;

  const { deployer } = await getNamedAccounts();
  let swapper: DeployResult, token: string, weth: string;
  if (network.name === "bscmainnet") {
    const factory = "0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73"; // pancakeswap factory
    swapper = await deploy("PancakeSwapper", {
      from: deployer,
      args: [factory],
      log: true,
    });
    token = "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56";
    weth = "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c";
  }
  if (network.name === "fantom") {
    const spookyFactory = "0x152eE697f2E276fA89E96742e9bB9aB1F2E61bE3"; // spookyswap factory

    swapper = await deploy("SpookySwapper", {
      from: deployer,
      args: [spookyFactory],
      log: true,
    });
    token = "0x04068DA6C83AFCFA0e13ba15A6696662335D5B75";
    weth = "0x21be370D5312f44cB42ce377BC9b8a0cEF1A4C83";
  }
  if (network.name === "avaxc") {
    const factory = "0x9Ad6C38BE94206cA50bb0d90783181662f0Cfa10"; // traderjoe factory
    swapper = await deploy("TraderJoeSwapper", {
      from: deployer,
      args: [factory],
      log: true,
    });
    token = "0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664"; // new USDC.e
    weth = "0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7";
  }
  if (network.name === "okex") {
    const factory = "0x709102921812B3276A65092Fe79eDfc76c4D4AFe"; // cherryswap factory
    swapper = await deploy("CherrySwapper", {
      from: deployer,
      args: [factory],
      log: true,
    });
    token = "0x382bb369d343125bfb2117af9c149795c6c65c50";
    weth = "0x8f8526dbfd6e38e3d8307702ca8469bae6c56c15";
  }

  const SinkCharger = await deploy("SinkCharger", {
    from: deployer,
    args: [token, weth, swapper.address],
    log: true,
  });
};
export default func;
func.tags = ["SinkCharger"];
