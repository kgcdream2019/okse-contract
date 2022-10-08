import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts, network, ethers } = hre;
  async function initializeOwners(
    contractName: string,
    contractAddress: string,
    _owners: string[]
  ) {
    try {
      let contract = await ethers.getContractAt(contractName, contractAddress);
      const txPure = await contract.initializeOwners(_owners);
      const sendTx = await txPure.wait();
      console.log(
        `${contractName} initializeOwners txHash = ${sendTx.transactionHash}`
      );
    } catch (e) {
      console.log(e.message);
    }
  }
  const { deploy } = deployments;
  // console.log(network);
  const { deployer } = await getNamedAccounts();
  // let _owners = [
  //   "0x11314C0b1bB3844eB43fF05D1E877d36cC1A134b",
  //   "0x09b2aFF4A268E40EdC9D3A0695339c3E9B84df9e",
  //   "0xba6BA085F0B6BE8f8A2D0f5a4F450c407fDC5aa4",
  // ];
  // owners from tobias
  let _owners = [
    "0x11314C0b1bB3844eB43fF05D1E877d36cC1A134b",
    "0xC533335b07e4E6B79763AAa65D45AF2c0606a016",
    "0x3Cdf6195e83a61e9D1842c70707e7B2fe10D2793",
  ];
  let okseCardAddress = "";
  if (network.name === "fantom") {
    okseCardAddress = "0x08B1fC2B48e5871354AF138B7909E9d1a04A89DD";
  } else if (network.name === "bscmainnet") {
    okseCardAddress = "0x40F5a9Bfd79585FFe39E93Efed59b84D27d6d593";
  } else if (network.name === "avaxc") {
    okseCardAddress = "0xe47C751c72EF1d2723e021F8153567Bd3e076a70";
  } else if (network.name === "okex") {
    okseCardAddress = "0xC6ff41994413fFc01b25c47BCdDf7c9D277d6059";
  }

  // LevelManager
  const LevelManager_Implementation = await deploy("LevelManager", {
    from: deployer,
    args: [okseCardAddress],
    log: true,
  });
  await initializeOwners(
    "LevelManager",
    LevelManager_Implementation.address,
    _owners
  );
};
export default func;
func.tags = ["LevelManager"];

