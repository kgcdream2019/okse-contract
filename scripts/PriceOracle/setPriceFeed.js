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
    else if (network.name === "arbitrum") {
        contractAddress = "0xcbeDEe9C29E92d61adD691dE46bc6d4F4Bb070A7";
    }
    else if (network.name === "optimism") {
        contractAddress = "0xcbeDEe9C29E92d61adD691dE46bc6d4F4Bb070A7";
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
        priceFeed = "0xCE5559AFAE07f96e54eA99B265A4b13b0cd75bcB"; // TwapPriceFeed

        // asset = "0x7db5af2B9624e1b3B4Bb69D6DeBd9aD1016A58Ac"; // VOLT
        // priceFeed = "0x536CEf7F539Ab4C71950d32b12a146bed7EDf084"; // TwapPriceFeed2

        // asset = "0x6679eB24F59dFe111864AEc72B443d1Da666B360"; // ARV
        // priceFeed = "0x750632A9a95bf557da96203219d9aE2C98Cd0A96"; // TwapPriceFeed2

        // asset = "0x156ab3346823B651294766e23e6Cf87254d68962"; // LUNA
        // priceFeed = "0xe2185a1ebB2303DE5B9A9776365538fcDD0D7525"; // TwapPriceFeed2
        
        // asset = "0xbA2aE424d960c26247Dd6c32edC70B295c744C43"; // DOGE
        // priceFeed = "0xcbeDEe9C29E92d61adD691dE46bc6d4F4Bb070A7"; // TwapPriceFeed2

        // asset = "0x23396cF899Ca06c4472205fC903bDB4de249D6fC"; // USTC
        // priceFeed = "0x33fb5277D65Eaf00c88bA279e502805f5ac8bb88"; // TwapPriceFeed

        // asset = "0x4b8285aB433D8f69CB48d5Ad62b415ed1a221e4f"; // MCRT
        // priceFeed = "0x7c3da197314eA6885F54FbF6Bee2A8e329fE88d1"; // TwapPriceFeed2

        // asset = "0x4b0f1812e5df2a09796481ff14017e6005508003"; // TWT
        // priceFeed = "0x31416EAbeF23DDB20700a342F4Dda310F3C38987"; // TwapPriceFeed2
        
        // asset = "0x352Cb5E19b12FC216548a2677bD0fce83BaE434B"; // BTT
        // priceFeed = "0xCE9673477918e8faEcabF3d05a538f85a8329173"; // TwapPriceFeed

        // asset = "0x85EAC5Ac2F758618dFa09bDbe0cf174e7d574D5B"; // TRX
        // priceFeed = "0xF4C5e535756D11994fCBB12Ba8adD0192D9b88be"; // ChainLink Feed

        // asset = "0xfb5b838b6cfeedc2873ab27866079ac55363d37e"; // FLOKI
        // priceFeed = "0x37140CCB0086D580128CE9c530dB4E565Feea805"; // TwapPriceFeed2

        // asset = "0x8fff93e810a2edaafc326edee51071da9d398e83"; // BRISE
        // priceFeed = "0x3238a6DE06cf949897CA580AdB82AA6aa6d300cD"; // TwapPriceFeed2

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
    else if(network.name === "arbitrum"){
        chainId = 42161;
        const WETH = "0x82af49447d8a07e3bd95bd0d56f35241523fbab1"; //WETH
        const USDC = "0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8"; // USDC
        const okse = "0x4313DDa7bc940F3f2B2ddDACF568300165C878CA";  // OKSE 
        asset = WETH
        priceFeed = "0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612";
        asset = USDC
        priceFeed = "0x50834F3163758fcC1Df9973b6e91f0F0F0434aD3";
    }
    else if(network.name === "optimism"){
        chainId = 10;
        const WETH = "0x4200000000000000000000000000000000000006"; //WETH
        const USDC = "0x7F5c764cBc14f9669B88837ca1490cCa17c31607"; // USDC
        const okse = "0x259479fBeb1CDe194afA297f36f4216e9C87728c";  // OKSE 
        asset = WETH
        priceFeed = "0x13e3Ee699D1909E989722E753853AE30b17e08c5";
        asset = USDC
        priceFeed = "0x16a9FA2FDa030272Ce99B29CF780dFA30361E0f3";
    }
    let signData = getSignData("setPriceFeed", 46, ["address", "address"], [asset, priceFeed])
    let { v, r, s, keys } = await getSignKeys(process.env.SECOND_OWNER, contractAddress, chainId, signData);
    console.log(signData, keys);
    let tx = await multiSigContract.setPriceFeed(signData, keys);
    console.log("--- tx = ", tx);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });