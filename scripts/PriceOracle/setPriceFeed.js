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
    let priceFeed;
    let chainId;
    if (network.name === "bscmainnet") {
        chainId = 56;
        asset = "0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82"; // Cake
        priceFeed = "0xB6064eD41d4f67e353768aA239cA86f4F73665a1"; // Cake Feed: https://docs.chain.link/docs/bnb-chain-addresses/
    }
    else if (network.name === "fantom") {
        chainId = 250;
        asset = "0x74e23df9110aa9ea0b6ff2faee01e740ca1c642e"; // TOR
        priceFeed = "0x3d2c3824CA1420a2e0a41EB1C09615d9ffD1c8Db"; // TOR Feed

        asset = "0x841fad6eae12c286d1fd18d1d525dffa75c7effe"; // BOO
        priceFeed = "0xf669612895D6bD2a688C436DCB5B916a382efd62"; // BOO Feed

        asset = "0x6c021ae822bea943b2e66552bde1d2696a53fbb7"; // TOMB
        priceFeed = "0xC85812c864736CE228ed681805f1DEbA6AaF6196"; // TOMB Feed

        asset = "0xfb98b335551a418cd0737375a2ea0ded62ea213b"; // MAI
        priceFeed = "0x233Eb9924eD755d05E938c154a86e9c8B4cCf3a7"; // MAI Feed

        asset = "0xeff6fcfbc2383857dd66ddf57efffc00d58b7d9d"; // JulD
        priceFeed = "0x10Ef6b469386CaF150001BBb3274cD8667045098"; // JulD Feed

        asset = "0x3b53D2C7B44d40BE05Fa5E2309FFeB6eB2492d88"; // OKSE
        priceFeed = "0xf8dFF85007bbA10B01cDB2e8F58E84654383EE48"; // OKSE Feed
    }
    else if (network.name === "avaxc") {
        chainId = 43114;

        asset = "0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E"; // USDC
        priceFeed = "0xF096872672F44d6EBA71458D74fe67F9a77a23B9"; // USDC Feed
        
        asset = "0xb31f66aa3c1e785363f0875a1b74e27b85fd66c7"; // AVAX
        priceFeed = "0xF096872672F44d6EBA71458D74fe67F9a77a23B9"; // AVAX Feed

        // asset = "0xbc7B0223Dd16cbc679c0D04bA3F4530D76DFbA87"; // OKSE
        // priceFeed = "0xC146794e568D1B4087F2D79Bf5e3fBF18Fe5Ff76"; // OKSE Feed
    }

    let signData = getSignData("setPriceFeed", 5, ["address", "address"], [asset, priceFeed])
    let { v, r, s, keys } = await getSignKeys(process.env.SECOND_OWNER, contractAddress, chainId, signData);
    console.log(signData, keys);
    await multiSigContract.setPriceFeed(signData, keys);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });