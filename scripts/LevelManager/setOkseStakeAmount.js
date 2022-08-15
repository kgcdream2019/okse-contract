const { network, ethers } = require("hardhat");
const { getSignData, getSignKeys } = require("../signature");
// yours, or create new ones.
async function main() {
    const [deployer] = await ethers.getSigners();
    let chainId;
    if (network.name === "bscmainnet") {
        contractAddress = "0x25994d5f8b7984AfDEb8c935B0b12CA8a6956D37";
        chainId = 56;
    }
    else if (network.name === "fantom") {
        contractAddress = "0xD962e220ED470084cC2dbF425784E8ccBCFE7Ce9";
        chainId = 250;
    }
    else if (network.name === "avaxc") {
        contractAddress = "0x40F5a9Bfd79585FFe39E93Efed59b84D27d6d593";
        chainId = 43114;
    }

    const multiSigContract = await ethers.getContractAt("LevelManager", contractAddress);
    const OkseStakeAmounts = [
        "5000000000000000000000",
        "25000000000000000000000",
        "50000000000000000000000",
        "100000000000000000000000",
        "250000000000000000000000"
    ]
    let index = 0;
    let _amounts = OkseStakeAmounts[index];

    let signData = getSignData("setOkseStakeAmount", index, ["uint256", "uint256"], [index, _amounts])
    let { v, r, s, keys } = await getSignKeys(process.env.SECOND_OWNER, contractAddress, chainId, signData);
    console.log(signData, keys);
    await multiSigContract.setOkseStakeAmount(signData, keys);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });