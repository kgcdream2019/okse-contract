const { network, ethers } = require("hardhat");
const { getSignData, getSignKeys } = require("./signature");
// yours, or create new ones.
async function main() {
    const [deployer] = await ethers.getSigners();
    const contractAddress = "0xe08b509e4779beC11603DD2FA746F8c1B30686A0";
    const multiSigContract = await ethers.getContractAt("MultiSigOwner", contractAddress);
    let newOwner = "0x11314C0b1bB3844eB43fF05D1E877d36cC1A134b";
    let signData = getSignData("transferOwnership", 2, ["address"], [newOwner])
    let { v, r, s, keys } = await getSignKeys(process.env.SECOND_OWNER, contractAddress, 250, signData);
    console.log(signData, keys);
    await multiSigContract.transferOwnership(signData, keys);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });