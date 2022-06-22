const { network, ethers } = require("hardhat");
const { getSignData, getSignKeys } = require("../signature");
// yours, or create new ones.
async function main() {
    const [deployer] = await ethers.getSigners();
    const contractAddress = "0x4fc6321F218C1eb8E959F97bD6F918AC738e7f7c";
    const multiSigContract = await ethers.getContractAt("MarketManager", contractAddress);
    // const market = "0x55d398326f99059fF775485246999027B3197955"; // USDT
    const market = "0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82"; // Cake
    let signData = getSignData("addMarket", 2, ["address"], [market])
    let { v, r, s, keys } = await getSignKeys(process.env.SECOND_OWNER, contractAddress, 56, signData);
    console.log(signData, keys);
    await multiSigContract.addMarket(signData, keys);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });