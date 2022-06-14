const { network, ethers } = require("hardhat");
const { getSignData, getSignKeys } = require("../signature");
// yours, or create new ones.
async function main() {
    const [deployer] = await ethers.getSigners();
    const contractAddress = "0x515695578eECd92d7747897df7756967912E678a";
    const multiSigContract = await ethers.getContractAt("OkseCardPriceOracle", contractAddress);
    const asset = "0x606FB7969fC1b5CAd58e64b12Cf827FB65eE4875";
    const price = "5000000";
    let signData = getSignData("setDirectPrice", 1, ["address", "uint256"], [asset, price])
    let { v, r, s, keys } = await getSignKeys(process.env.SECOND_OWNER, contractAddress, 56, signData);
    console.log(signData, keys);
    await multiSigContract.setDirectPrice(signData, keys);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });