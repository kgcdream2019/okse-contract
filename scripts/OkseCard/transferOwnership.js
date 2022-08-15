const { network, ethers } = require("hardhat");
const { getSignData, getSignKeys } = require("../signature");
// yours, or create new ones.
async function main() {
    const [deployer] = await ethers.getSigners();
    let chainId;
    if (network.name === "bscmainnet") {
        contractAddress = "0x40F5a9Bfd79585FFe39E93Efed59b84D27d6d593";
        chainId = 56;
    }
    else if (network.name === "fantom") {
        contractAddress = "0x08B1fC2B48e5871354AF138B7909E9d1a04A89DD";
        chainId = 250;
    }
    else if (network.name === "avaxc") {
        contractAddress = "0xe47C751c72EF1d2723e021F8153567Bd3e076a70";
        chainId = 43114;
    }

    const multiSigContract = await ethers.getContractAt("OkseCard", contractAddress);
    // const oldOwner = "0xF92d6d2c833434EF1Cc9284f9890A17d42497CCB"
    // let newOwner = "0xC533335b07e4E6B79763AAa65D45AF2c0606a016"
    // const oldOwner = "0x0Ed78A9DE439d4aA69596402A0947819655d3c05"
    let newOwner = "0x3Cdf6195e83a61e9D1842c70707e7B2fe10D2793"

    let signData = getSignData("transferOwnership", 2, ["address"], [newOwner])
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