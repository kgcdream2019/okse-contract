const { network, ethers } = require("hardhat");
const { getSignData, getSignKeys } = require("../signature");
// yours, or create new ones.
async function main() {
    let chainId;
    let contractAddress, _priceOracle, _swapper, _limitManager, _levelManager, _marketManager, _cashbackManager;
    if (network.name === "bscmainnet") {
        chainId = 56;
        contractAddress = "0x40F5a9Bfd79585FFe39E93Efed59b84D27d6d593";
        _priceOracle = "0x515695578eECd92d7747897df7756967912E678a";
        _swapper = "0x80e579540Bd73a59dA93c883Fb0a96d8Fb7a19A9";
        _limitManager = "0x9666657d324F866DA07E418C91628Fd399088f37"
        _levelManager = "0x25994d5f8b7984AfDEb8c935B0b12CA8a6956D37"
        _marketManager = "0x4fc6321F218C1eb8E959F97bD6F918AC738e7f7c"
        _cashbackManager = "0x0c123aE1cDaFbD71f9Bf8966c19081E47115b115";
    }
    else if (network.name === "fantom") {
        chainId = 250
        contractAddress = "0x08B1fC2B48e5871354AF138B7909E9d1a04A89DD";
        _priceOracle = "0x606FB7969fC1b5CAd58e64b12Cf827FB65eE4875";
        _swapper = "0x75A35B5216cbEfE2AF2b3E868bb979A482c90f78";
        _limitManager = "0x682C09d078f52Ae34Df2fA38EDf0BfB158d332d4"
        _levelManager = "0xD962e220ED470084cC2dbF425784E8ccBCFE7Ce9"
        _marketManager = "0xC71438f3b31D133ff79F5Ad3ff5C0C0aF9AA4835"
        _cashbackManager = "0xe2DE49356D55bBC1D56AA57099FFdbE1868B427A";
    }
    else if (network.name === "avaxc") {
        chainId = 43114
        contractAddress = "0xe47C751c72EF1d2723e021F8153567Bd3e076a70";
        _priceOracle = "0x4141c9420DF74d2379c1D3CD983a8c306Aa1A6b4";
        _swapper = "0x515695578eECd92d7747897df7756967912E678a";
        _limitManager = "0x25994d5f8b7984AfDEb8c935B0b12CA8a6956D37"
        _levelManager = "0x40F5a9Bfd79585FFe39E93Efed59b84D27d6d593"
        _marketManager = "0x30342EBb1fa044A9BBFd4256973B5f551e654103"
        _cashbackManager = "0x4fc6321F218C1eb8E959F97bD6F918AC738e7f7c";
    }
    else if (network.name === "okex") {
        chainId = 66
        contractAddress = "0xC6ff41994413fFc01b25c47BCdDf7c9D277d6059";
        _priceOracle = "0xff2a9c67993f37a8F7793EA286bFFDc57521a187";
        _swapper = "0xb2c4A6b8febDCD4D56c402D7677AD5f62d36a557";
        _limitManager = "0xb81C987Fede22fF2095808713C01B61944792Db1"
        _levelManager = "0x22CAe3f82c6b8AAA2457175fD6A788aA2940bEe6"
        _marketManager = "0x3CE2AFD4dA06a09F8b4c5715Ff74E83EAC3633d0"
        _cashbackManager = "0xB1152Aaf71c44a8292d550c8c077D6Fc998D9CB9";
    }
    else {
        throw "invalid network"
    }
    const [deployer] = await ethers.getSigners();

    
    const multiSigContract = await ethers.getContractAt("OkseCard", contractAddress);


    let signData = getSignData("setContractAddress", 8, ["address", "address", "address", "address", "address", "address"],
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