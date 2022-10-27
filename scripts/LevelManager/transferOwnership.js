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
    // const oldOwner = "0xF92d6d2c833434EF1Cc9284f9890A17d42497CCB"
    // let newOwner = "0xC533335b07e4E6B79763AAa65D45AF2c0606a016"
    // const oldOwner = "0x0Ed78A9DE439d4aA69596402A0947819655d3c05"
    let newOwner = "0x3Cdf6195e83a61e9D1842c70707e7B2fe10D2793"

    let signData = getSignData("transferOwnership", 7, ["address"], [newOwner])
    let { v, r, s, keys } = await getSignKeys(process.env.SECOND_OWNER, contractAddress, chainId, signData);
    console.log(signData, keys);
    const tx = await multiSigContract.stransferOwnership(signData, keys);
    console.log("--- tx = ", tx);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });