const { network, ethers } = require("hardhat");
const { getSignData, getSignKeys } = require("../signature");
// yours, or create new ones.
async function main() {
    const [deployer] = await ethers.getSigners();
    let chainId;
    if (network.name === "bscmainnet") {
        contractAddress = "0x9666657d324F866DA07E418C91628Fd399088f37";
        chainId = 56;
    }
    else if (network.name === "fantom") {
        contractAddress = "0x682C09d078f52Ae34Df2fA38EDf0BfB158d332d4";
        chainId = 250;
    }
    else if (network.name === "avaxc") {
        contractAddress = "0x25994d5f8b7984AfDEb8c935B0b12CA8a6956D37";
        chainId = 43114;
    }

    const multiSigContract = await ethers.getContractAt("LimitManager", contractAddress);
    const limits = [
        "250000000000000000000",
        "500000000000000000000",
        "2500000000000000000000",
        "5000000000000000000000",
        "10000000000000000000000",
        "50000000000000000000000"]
    let index = 0;
    let _amounts = limits[index];

    let signData = getSignData("setDailyLimit", index, ["uint256", "uint256"], [index, _amounts])
    let { v, r, s, keys } = await getSignKeys(process.env.SECOND_OWNER, contractAddress, chainId, signData);
    console.log(signData, keys);
    await multiSigContract.setDailyLimit(signData, keys);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });