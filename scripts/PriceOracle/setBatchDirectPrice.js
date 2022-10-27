const { network, ethers } = require("hardhat");
const { getSignData, getSignKeys } = require("../signature");
// yours, or create new ones.
async function main() {
    const [deployer] = await ethers.getSigners();
    const contractAddress = "0x5E79A2474281AE517689790eE8457741726c793e";
    const multiSigContract = await ethers.getContractAt("OkseCardPriceOracle", contractAddress);
    const _assets = ["0x3b53D2C7B44d40BE05Fa5E2309FFeB6eB2492d88"];
    const _prices = ["325800"];
    let signData = getSignData("setBatchDirectPrice", 15, ["address[]", "uint256[]"], [_assets, _prices])
    let { v, r, s, keys } = await getSignKeys(process.env.SECOND_OWNER, contractAddress, 250, signData);
    console.log(signData, keys);
    const tx = await multiSigContract.ssetBatchDirectPrice(signData, keys);
    console.log("--- tx = ", tx);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });