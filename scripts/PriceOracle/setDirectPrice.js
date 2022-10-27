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
    else if (network.name === "okex") {
        contractAddress = "0xff2a9c67993f37a8F7793EA286bFFDc57521a187";
    }
    const multiSigContract = await ethers.getContractAt("OkseCardPriceOracle", contractAddress);
    let asset;
    let price;
    let chainId;
    if (network.name === "bscmainnet") {
        chainId = 56;
        asset = "0x606FB7969fC1b5CAd58e64b12Cf827FB65eE4875";
        price = "0";
    }
    else if (network.name === "fantom") {
        chainId = 250;
        asset = "0x3b53D2C7B44d40BE05Fa5E2309FFeB6eB2492d88";
        price = "0";
    }
    else if (network.name === "avaxc") {
        chainId = 43114;
        asset = "0xbc7B0223Dd16cbc679c0D04bA3F4530D76DFbA87";
        price = "0";
    }
    else if (network.name === "okex") {
        chainId = 66;
        asset = "0x382bb369d343125bfb2117af9c149795c6c65c50"; // USDT
        price = "100000000"; // 1$s

        asset = "0xA844C05ae51DdafA6c4d5c801DE1Ef5E6F626bEC"; // OKSE
        price = "10000000"; // 0.1$
        
    }
    let signData = getSignData("setDirectPrice", 7, ["address", "uint256"], [asset, price])
    let { v, r, s, keys } = await getSignKeys(process.env.SECOND_OWNER, contractAddress, chainId, signData);
    console.log(signData, keys);
    const tx = await multiSigContract.ssetDirectPrice(signData, keys);
    console.log("--- tx = ", tx);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });