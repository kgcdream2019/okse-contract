import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts, network, ethers } = hre;
  const { deploy } = deployments;

  const { deployer } = await getNamedAccounts();
  const multisigOwner = await deploy("MultiSigOwner", {
    from: deployer,
    args: [],
    log: true,
  });
  let _owners = [
    "0xF92d6d2c833434EF1Cc9284f9890A17d42497CCB",
    "0x11314C0b1bB3844eB43fF05D1E877d36cC1A134b",
    "0x0Ed78A9DE439d4aA69596402A0947819655d3c05",
  ];
  let multisigOwnerContract = await ethers.getContractAt("MultiSigOwner", multisigOwner.address);
  // let multisigOwnerContract = await ethers.getContractAt(
  //   "MultiSigOwner",
  //   "0x5a71a59B6d76af9b5c1a1fFB3230126aD6b6fC65"
  // );
  await multisigOwnerContract.initializeOwners(_owners);
};
export default func;
func.tags = ["MultiSigOwner"];
