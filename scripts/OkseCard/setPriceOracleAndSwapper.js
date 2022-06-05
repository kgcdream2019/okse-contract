const { network, ethers } = require("hardhat");
const { getSignData, getSignKeys } = require("../signature");
// yours, or create new ones.
async function main() {
    const [deployer] = await ethers.getSigners();
    const contractAddress = "0x649a2a7ddA2d4D0C0E8B8A98644c6729e1CD343b";
    const multiSigContract = await ethers.getContractAt("OkseCard", contractAddress);
    const _priceOracle = "0x0C2e6a7466CF85d428BCB36103299A2DF0F5Ff6C";
    const _swapper = "0xF8cA7f66E8375d1c206057ced2175fD0199C0915";
    let signData = getSignData("setPriceOracleAndSwapper", 3, ["address", "address"], [_priceOracle, _swapper])
    let { v, r, s, keys } = await getSignKeys(process.env.SECOND_OWNER, contractAddress, 250, signData);
    console.log(signData, keys);
    await multiSigContract.setPriceOracleAndSwapper(signData, keys);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });