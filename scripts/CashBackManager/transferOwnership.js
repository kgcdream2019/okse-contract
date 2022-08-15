const { network, ethers } = require("hardhat");
const { getSignData, getSignKeys } = require("../signature");
// yours, or create new ones.
async function main() {
    const [deployer] = await ethers.getSigners();
    let chainId;
    if (network.name === "bscmainnet") {
        contractAddress = "0x0c123aE1cDaFbD71f9Bf8966c19081E47115b115";
        chainId = 56;
    }
    else if (network.name === "fantom") {
        contractAddress = "0xe2DE49356D55bBC1D56AA57099FFdbE1868B427A";
        chainId = 250;
    }
    else if (network.name === "avaxc") {
        contractAddress = "0x4fc6321F218C1eb8E959F97bD6F918AC738e7f7c";
        chainId = 43114;
    }

    const multiSigContract = await ethers.getContractAt("CashBackManager", contractAddress);
    // const oldOwner = "0xF92d6d2c833434EF1Cc9284f9890A17d42497CCB"
    // let newOwner = "0xC533335b07e4E6B79763AAa65D45AF2c0606a016"
    // const oldOwner = "0x0Ed78A9DE439d4aA69596402A0947819655d3c05"
    let newOwner = "0x3Cdf6195e83a61e9D1842c70707e7B2fe10D2793"

    let signData = getSignData("transferOwnership", 1, ["address"], [newOwner])
    let { v, r, s, keys } = await getSignKeys(process.env.SECOND_OWNER, contractAddress, chainId, signData);
    console.log(signData, keys);
    await multiSigContract.transferOwnership(signData, keys);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });