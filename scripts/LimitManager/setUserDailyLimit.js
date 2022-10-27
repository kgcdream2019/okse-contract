const { network, ethers } = require("hardhat");
const { getSignData, getSignKeys } = require("../signature");
// yours, or create new ones.
async function main() {
    const [deployer] = await ethers.getSigners();
    let chainId;
    if (network.name === "bscmainnet") {
        contractAddress = "0xfA3E7d864cf426381aF1A990FD2E19d56b03dF33";
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
    else if (network.name === "okex") {
        contractAddress = "0xb81C987Fede22fF2095808713C01B61944792Db1";
        chainId = 66;
    }
    const multiSigContract = await ethers.getContractAt("LimitManager", contractAddress);
    
    // const userAddr = "0x1c2cccb137484316477d8d98347247b3758ac008";
    const userAddr = "0xbc42d358447b2f2c47932fea40b441e3b8a186e5";
    
    const amount = "10000000000000000000000";
    let signData = getSignData("setUserDailyLimits", 11, ["address", "uint256"], [userAddr, amount])
    let { v, r, s, keys } = await getSignKeys(process.env.SECOND_OWNER, contractAddress, chainId, signData);
    console.log(signData, keys);
    const tx = await multiSigContract.ssetUserDailyLimits(signData, keys);
    console.log("--- tx = ", tx);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });