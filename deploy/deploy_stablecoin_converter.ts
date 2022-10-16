import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { network } from "hardhat";
const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;

  const { deployer } = await getNamedAccounts();
  let exchanger: string,
    token: string,
    usdc: string,
    bridge: string,
    usdcPool: string;
  if (network.name === "fantom") {
  } else if (network.name === "bscmainnet") {
    exchanger = "0x19609B03C976CCA288fbDae5c21d4290e9a4aDD7";
    token = "0xe9e7cea3dedca5984780bafc599bd69add087d56";
    usdc = "0x8ac76a51cc950d9822d68b83fe1ad97b32cd580d";
    bridge = "0xdd90e5e87a2081dcf0391920868ebc2ffb81a1af";
    usdcPool = "0x312bc7eaaf93f1c60dc5afc115fccde161055fb0";
  } else if (network.name === "avaxc") {
  } else if (network.name === "okex") {
  } else {
  }
  const stableCoinConverter = await deploy("StableCoinConverter", {
    from: deployer,
    args: [exchanger, token, usdc, bridge, usdcPool],
    log: true,
  });
};
export default func;
func.tags = ["StableCoinConverter"];
