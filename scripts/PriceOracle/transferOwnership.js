const { network, ethers } = require("hardhat");
const { getSignData, getSignKeys } = require("../signature");
// yours, or create new ones.
async function main() {
    const [deployer] = await ethers.getSigners();
    let chainId;
    if (network.name === "bscmainnet") {
        contractAddress = "0x515695578eECd92d7747897df7756967912E678a";
        chainId = 56;
    }
    else if (network.name === "fantom") {
        contractAddress = "0x606FB7969fC1b5CAd58e64b12Cf827FB65eE4875";
        chainId = 250;
    }
    else if (network.name === "avaxc") {
        contractAddress = "0x4141c9420DF74d2379c1D3CD983a8c306Aa1A6b4";
        chainId = 43114;
    }

    const multiSigContract = await ethers.getContractAt("OkseCardPriceOracle", contractAddress);
    // const oldOwner = "0xF92d6d2c833434EF1Cc9284f9890A17d42497CCB"
    let newOwner = "0xba6BA085F0B6BE8f8A2D0f5a4F450c407fDC5aa4"
    // const oldOwner = "0x0Ed78A9DE439d4aA69596402A0947819655d3c05"
    // let newOwner = "0x09b2aFF4A268E40EdC9D3A0695339c3E9B84df9e"

    let signData = getSignData("transferOwnership", 10, ["address"], [newOwner])
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