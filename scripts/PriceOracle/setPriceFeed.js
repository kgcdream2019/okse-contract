const { network, ethers } = require("hardhat");
const { getSignData, getSignKeys } = require("../signature");
// yours, or create new ones.
async function main() {
    const [deployer] = await ethers.getSigners();
    const contractAddress = "0x515695578eECd92d7747897df7756967912E678a";
    const multiSigContract = await ethers.getContractAt("OkseCardPriceOracle", contractAddress);
    const asset = "0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82"; // Cake
    const priceFeed = "0xB6064eD41d4f67e353768aA239cA86f4F73665a1"; // Cake Feed: https://docs.chain.link/docs/bnb-chain-addresses/
    let signData = getSignData("setPriceFeed", 2, ["address", "address"], [asset, priceFeed])
    let { v, r, s, keys } = await getSignKeys(process.env.SECOND_OWNER, contractAddress, 56, signData);
    console.log(signData, keys);
    await multiSigContract.setPriceFeed(signData, keys);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });