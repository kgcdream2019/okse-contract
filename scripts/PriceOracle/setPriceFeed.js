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
    let priceFeed;
    let chainId;
    if (network.name === "bscmainnet") {
        chainId = 56;
        // asset = "0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82"; // Cake
        // priceFeed = "0xB6064eD41d4f67e353768aA239cA86f4F73665a1"; // Cake Feed: https://docs.chain.link/docs/bnb-chain-addresses/
        
        // asset = "0x1d6cbdc6b29c6afbae65444a1f65ba9252b8ca83"; // Tor
        // priceFeed = "0xff2a9c67993f37a8F7793EA286bFFDc57521a187"; // TwapPriceFeed

        // asset = "0x2859e4544C4bB03966803b044A93563Bd2D0DD4D"; // SHIB
        // priceFeed = "0x3BE94aD5dDB81119ab88B1771f579C2D7a44A7f3"; // TWAPPriceFeed2

        // asset = "0x0782b6d8c4551B9760e74c0545a9bCD90bdc41E5"; // HAY
        // priceFeed = "0xf185EbbB4661eFf878e03af42A20D5e69BBE070c"; // TwapPriceFeed

        asset = "0xAD6742A35fB341A9Cc6ad674738Dd8da98b94Fb1"; // WOM
        priceFeed = "0xeEEe4D6465d2D5A341340f5dcD7fD0c379056Fe6"; // TwapPriceFeed

        asset = "0x606FB7969fC1b5CAd58e64b12Cf827FB65eE4875"; // OKSE
        priceFeed = "0x166088f58ca5A527F9C39E287Ee154bC0746140d"; // TwapPriceFeed2

        asset = "0x7db5af2B9624e1b3B4Bb69D6DeBd9aD1016A58Ac"; // VOLT
        priceFeed = "0x536CEf7F539Ab4C71950d32b12a146bed7EDf084"; // TwapPriceFeed2

        asset = "0x6679eB24F59dFe111864AEc72B443d1Da666B360"; // ARV
        priceFeed = "0x750632A9a95bf557da96203219d9aE2C98Cd0A96"; // TwapPriceFeed2
        
    }
    else if (network.name === "fantom") {
        chainId = 250;
        asset = "0x74e23df9110aa9ea0b6ff2faee01e740ca1c642e"; // TOR
        priceFeed = "0x6BF463087c8A20Ae5F983aE2109656caBE0772Dc"; // TOR Feed

        asset = "0x841fad6eae12c286d1fd18d1d525dffa75c7effe"; // BOO
        priceFeed = "0xff2a9c67993f37a8F7793EA286bFFDc57521a187"; // BOO Feed

        asset = "0x6c021ae822bea943b2e66552bde1d2696a53fbb7"; // TOMB
        priceFeed = "0x97F8a06AE892d10c3BB1058F0eccfB81195Df1e4"; // TOMB Feed

        asset = "0xfb98b335551a418cd0737375a2ea0ded62ea213b"; // MAI
        priceFeed = "0xE91DE865117EFAFfCC4dAD5673B0b12f6168511c"; // MAI Feed

        asset = "0xeff6fcfbc2383857dd66ddf57efffc00d58b7d9d"; // JulD
        priceFeed = "0xE7C22B2de57C3297419194256EDb73808F6f62d8"; // JulD Feed

        // asset = "0x3b53D2C7B44d40BE05Fa5E2309FFeB6eB2492d88"; // OKSE
        // priceFeed = "0x0aaBC7C5380E01Bd30e555aCa966d9C8A86751f5"; // OKSE Feed
    }
    else if (network.name === "avaxc") {
        chainId = 43114;

        asset = "0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E"; // USDC
        priceFeed = "0xF096872672F44d6EBA71458D74fe67F9a77a23B9"; // USDC Feed
        
        asset = "0xb31f66aa3c1e785363f0875a1b74e27b85fd66c7"; // AVAX
        priceFeed = "0x0A77230d17318075983913bC2145DB16C7366156"; // AVAX Feed

        asset = "0x6e84a6216eA6dACC71eE8E6b0a5B7322EEbC0fDd"; // JOE
        priceFeed = "0x02d35d3a8ac3e1626d3ee09a78dd87286f5e8e3a"; // JOE Feed

        asset = "0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664"; // USDC.e
        priceFeed = "0xF096872672F44d6EBA71458D74fe67F9a77a23B9"; // USDC Feed

        // asset = "0xbc7B0223Dd16cbc679c0D04bA3F4530D76DFbA87"; // OKSE
        // priceFeed = "0xC146794e568D1B4087F2D79Bf5e3fBF18Fe5Ff76"; // OKSE Feed
    }
    else if(network.name === "okex"){
        chainId = 66;
        const WOKT = "0x8f8526dbfd6e38e3d8307702ca8469bae6c56c15"; //WOKT
        const USDT = "0x382bb369d343125bfb2117af9c149795c6c65c50"; // USDT
        const okse = "0xA844C05ae51DdafA6c4d5c801DE1Ef5E6F626bEC";  // OKSE 
        asset = WOKT
        priceFeed = "0x72B803Dd976E2277D8c16163703BE2cDe0E0E8D3";
        asset = USDT
        priceFeed = "0x61942e306965184cD92BE58818F99EC265d62B6F";
        asset = okse
        priceFeed = "0xde91e495d0b79f74e9cAc6c2bdcf2c07d9Aba74D";
        
    }

    let signData = getSignData("setPriceFeed", 30, ["address", "address"], [asset, priceFeed])
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