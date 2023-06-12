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
    else if (network.name === "polygon") {
        contractAddress = "0xcbeDEe9C29E92d61adD691dE46bc6d4F4Bb070A7";
    }
    else if (network.name === "arbitrum") {
        contractAddress = "0xcbeDEe9C29E92d61adD691dE46bc6d4F4Bb070A7";
    }
    else if (network.name === "optimism") {
        contractAddress = "0xcbeDEe9C29E92d61adD691dE46bc6d4F4Bb070A7";
    }
    else if (network.name === "zksyncMainnet") {
        contractAddress = "0x3727d9097aC27F57d81124c8290e63843CBb8c96";
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
    else if (network.name === "polygon") {
        chainId = 137;
        asset = "0xFf1674D39dEf5d3840f4021FAD2c5D4F20520557"; // OKSE
        price = "10000000"; // 0.1$

    }
    else if (network.name === "arbitrum") {
        chainId = 42161;
        asset = "0x4313DDa7bc940F3f2B2ddDACF568300165C878CA"; // OKSE
        price = "10000000"; // 0.1$
    }
    else if (network.name === "optimism") {
        chainId = 10;
        asset = "0x259479fBeb1CDe194afA297f36f4216e9C87728c"; // OKSE
        price = "10000000"; // 0.1$
    }
    else if(network.name === "zksyncMainnet"){
        chainId = 324;
        asset = "0x8483bf6d5E45e467f2979c5d51B76100AAB60294"; // OKSE
        price = "3084000"; // 0.03084$
        asset = "0x3355df6D4c9C3035724Fd0e3914dE96A5a83aaf4"; // USDC
        price = "100000000"; // 1$
    }
    let signData = getSignData("setDirectPrice", 11, ["address", "uint256"], [asset, price])
    let { v, r, s, keys } = await getSignKeys(process.env.SECOND_OWNER, contractAddress, chainId, signData);
    console.log(signData, keys);
    const tx = await multiSigContract.setDirectPrice(signData, keys);
    console.log("--- tx = ", tx);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });