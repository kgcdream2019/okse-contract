import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts, network } = hre;
  const { deploy } = deployments;

  const { deployer } = await getNamedAccounts();


    const GmxTester_Implementation = await deploy("GmxTester", {
      from: deployer,
      args: [],
      log: true,
    });
};
export default func;
func.tags = ["GmxTester"];
