import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts, network } = hre;
  const { deploy } = deployments;

  const { deployer } = await getNamedAccounts();
  if(network.name === "zksyncMainnet") {
    // weth
    const _token = "0x5AEa5775959fBC2557Cc8789bC1bf90A239D9a91";
    const _USDC = "0x3355df6D4c9C3035724Fd0e3914dE96A5a83aaf4";
    const _swapper = "0xB5F6287F0Feb4DeA02b6901f1AB82d169D788f95";
    const SyncPriceFeed = await deploy("SyncSwapPriceFeed", {
      from: deployer,
      args: [_token, _USDC, _swapper],
      log: true,
    });
  }
};
export default func;
func.tags = ["SyncSwapPriceFeed"];
