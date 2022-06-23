const { network, ethers } = require("hardhat");
const { getSignData, getSignKeys } = require("../signature");
// yours, or create new ones.
async function main() {
    const [deployer] = await ethers.getSigners();
    if (network.name === "bscmainnet") {
        contractAddress = "0x4fc6321F218C1eb8E959F97bD6F918AC738e7f7c";
    }
    else if (network.name === "fantom") {
        contractAddress = "0xC71438f3b31D133ff79F5Ad3ff5C0C0aF9AA4835";
    }

    const multiSigContract = await ethers.getContractAt("MarketManager", contractAddress);
    let market;
    if (network.name === "bscmainnet") {
        chainId = 56;
        // market = "0x55d398326f99059fF775485246999027B3197955"; // USDT
        market = "0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82"; // Cake
    }
    else if (network.name === "fantom") {
        chainId = 250;
        market = "0x841fad6eae12c286d1fd18d1d525dffa75c7effe"; // BOO
        market = "0x321162Cd933E2Be498Cd2267a90534A804051b11"; // BTC
        market = "0x74b23882a30290451A17c44f4F05243b6b58C76d"; // ETH
        market = "0xfb98b335551a418cd0737375a2ea0ded62ea213b"; // MIMATIC
        market = "0x6c021Ae822BEa943b2E66552bDe1D2696a53fbB7"; // TOMB
        market = "0x74e23df9110aa9ea0b6ff2faee01e740ca1c642e"; // TOR
    }
    
    let signData = getSignData("addMarket", 6, ["address"], [market])
    let { v, r, s, keys } = await getSignKeys(process.env.SECOND_OWNER, contractAddress, chainId, signData);
    console.log(signData, keys);
    await multiSigContract.addMarket(signData, keys);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });