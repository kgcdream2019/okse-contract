const { network, ethers } = require("hardhat");
const { getSignData, getSignKeys } = require("../signature");
// yours, or create new ones.
async function main() {
    const [deployer] = await ethers.getSigners();
    let contractAddress;
    if (network.name === "bscmainnet") {
        contractAddress = "0x515695578eECd92d7747897df7756967912E678a";
    }
    else if (network.name === "fantom") {
        contractAddress = "0x606FB7969fC1b5CAd58e64b12Cf827FB65eE4875";
    }
    else if (network.name === "avaxc") {
        contractAddress = "0x4141c9420DF74d2379c1D3CD983a8c306Aa1A6b4";
    }
    const multiSigContract = await ethers.getContractAt("OkseCardPriceOracle", contractAddress);
    let asset;
    let price;
    let chainId;
    if (network.name === "bscmainnet") {
        chainId = 56;
        asset = "0x606FB7969fC1b5CAd58e64b12Cf827FB65eE4875";
        price = "5000000";
    }
    else if (network.name === "fantom") {
        chainId = 250;
        asset = "0x3b53D2C7B44d40BE05Fa5E2309FFeB6eB2492d88";
        price = "5000000";
    }
    else if (network.name === "avaxc") {
        chainId = 43114;
        asset = "0xbc7B0223Dd16cbc679c0D04bA3F4530D76DFbA87";
        price = "5000000";
    }
    let signData = getSignData("setDirectPrice", 4, ["address", "uint256"], [asset, price])
    let { v, r, s, keys } = await getSignKeys(process.env.SECOND_OWNER, contractAddress, chainId, signData);
    console.log(signData, keys);
    await multiSigContract.setDirectPrice(signData, keys);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });