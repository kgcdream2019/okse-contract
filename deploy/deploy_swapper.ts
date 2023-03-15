import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts, network } = hre;
  const { deploy } = deployments;

  const { deployer } = await getNamedAccounts();
  if (network.name === "bscmainnet") {
    const factory = "0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73"; // pancakeswap factory
    const Swapper = await deploy("PancakeSwapper", {
      from: deployer,
      args: [factory],
      log: true,
    });
  }
  if (network.name === "fantom") {
    const spookyFactory = "0x152eE697f2E276fA89E96742e9bB9aB1F2E61bE3"; // spookyswap factory

    const SpookySwapper = await deploy("SpookySwapper", {
      from: deployer,
      args: [spookyFactory],
      log: true,
    });
  }
  if (network.name === "polygon") {
    const factory = "0xc35DADB65012eC5796536bD9864eD8773aBc74C4"; // sushiswap factory
    const SushiSwapper = await deploy("SushiSwapper", {
      from: deployer,
      args: [factory],
      log: true,
    });
  }
  if(network.name === "avaxc") {
    const factory = "0x9Ad6C38BE94206cA50bb0d90783181662f0Cfa10"; // traderjoe factory
    const TraderjoeSwapper = await deploy("TraderJoeSwapper", {
      from: deployer,
      args: [factory],
      log: true,
    });
  }
  if(network.name === "okex") {
    const factory = "0x709102921812B3276A65092Fe79eDfc76c4D4AFe"; // cherryswap factory
    const CherrySwapper = await deploy("CherrySwapper", {
      from: deployer,
      args: [factory],
      log: true,
    });
  }
};
export default func;
func.tags = ["Swapper"];
