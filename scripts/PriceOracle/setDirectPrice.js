const { network, ethers } = require("hardhat");
const { getSignData, getSignKeys } = require("../signature");
// yours, or create new ones.
async function main() {
    const [deployer] = await ethers.getSigners();
    const contractAddress = "0x5E79A2474281AE517689790eE8457741726c793e";
    const multiSigContract = await ethers.getContractAt("OkseCardPriceOracle", contractAddress);
    const asset = "0xEFF6FcfBc2383857Dd66ddf57effFC00d58b7d9D";
    const price = "325800";
    let signData = getSignData("setDirectPrice", 3, ["address", "uint256"], [asset, price])
    let { v, r, s, keys } = await getSignKeys(process.env.SECOND_OWNER, contractAddress, 250, signData);
    console.log(signData, keys);
    await multiSigContract.setDirectPrice(signData, keys);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });