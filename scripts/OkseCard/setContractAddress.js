const { network, ethers } = require("hardhat");
const { getSignData, getSignKeys } = require("../signature");
// yours, or create new ones.
async function main() {
    let chainId;
    if (network === "bscmainnet") {
        chainId = 56;
    }
    else if (network === "fantom") {
        chainId = 250
    }
    else {
        throw "invalid network"
    }
    const [deployer] = await ethers.getSigners();
    const contractAddress = "0x40F5a9Bfd79585FFe39E93Efed59b84D27d6d593";
    const multiSigContract = await ethers.getContractAt("OkseCard", contractAddress);
    const _priceOracle = "0x515695578eECd92d7747897df7756967912E678a";
    const _swapper = "0x0aaBC7C5380E01Bd30e555aCa966d9C8A86751f5";
    const _limitManager = "0x9666657d324F866DA07E418C91628Fd399088f37"
    const _levelManager = "0x25994d5f8b7984AfDEb8c935B0b12CA8a6956D37"
    const _marketManager = "0x4fc6321F218C1eb8E959F97bD6F918AC738e7f7c"
    const _cashbackManager = "0x0c123aE1cDaFbD71f9Bf8966c19081E47115b115";
    let signData = getSignData("setContractAddress", 1, ["address", "address", "address", "address", "address", "address"],
        [_priceOracle, _swapper, _limitManager, _levelManager, _marketManager, _cashbackManager])
    let { v, r, s, keys } = await getSignKeys(process.env.SECOND_OWNER, contractAddress, chainId, signData);
    console.log(signData, keys);
    await multiSigContract.setContractAddress(signData, keys);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });