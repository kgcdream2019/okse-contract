const { network, ethers } = require("hardhat");
const { getSignData, getSignKeys } = require("../signature");
// yours, or create new ones.
async function main() {
    let chainId;
    let contractAddress, _monthlyFeeAmount, _okseMonthlyProfit, _withdrawFeePercent, newBuyFeePercent, newBuyTxFee;
    if (network.name === "bscmainnet") {
        chainId = 56;
        contractAddress = "0x40F5a9Bfd79585FFe39E93Efed59b84D27d6d593";
        _monthlyFeeAmount = "6990000000000000000";
        _okseMonthlyProfit = "1000";
        _withdrawFeePercent = "0"
        newBuyFeePercent = "250" 
        newBuyTxFee = "700000000000000000" // 0.7
    }
    else if (network.name === "fantom") {
        chainId = 250
        contractAddress = "0x08B1fC2B48e5871354AF138B7909E9d1a04A89DD";
        _monthlyFeeAmount = "6990000000000000000";
        _okseMonthlyProfit = "1000";
        _withdrawFeePercent = "0"
        newBuyFeePercent = "250" 
        newBuyTxFee = "200000000000000000" // 0.2
    }
    else if (network.name === "avaxc") {
        chainId = 43114
        contractAddress = "0xe47C751c72EF1d2723e021F8153567Bd3e076a70";
        _monthlyFeeAmount = "6990000000000000000";
        _okseMonthlyProfit = "1000";
        _withdrawFeePercent = "0"
        newBuyFeePercent = "250" 
        newBuyTxFee = "200000000000000000" // 0.2
    }
    else if (network.name === "okex") {
        chainId = 66
        contractAddress = "0xC6ff41994413fFc01b25c47BCdDf7c9D277d6059";
        _monthlyFeeAmount = "6990000000000000000";
        _okseMonthlyProfit = "1000";
        _withdrawFeePercent = "0"
        newBuyFeePercent = "250"; 
        newBuyTxFee = "10000000000000000" //0.01
    }
    else {
        throw "invalid network"
    }
    const [deployer] = await ethers.getSigners();


    const multiSigContract = await ethers.getContractAt("OkseCard", contractAddress);


    let signData = getSignData("setFeeValues", 9, ["uint256", "uint256", "uint256", "uint256", "uint256"],
        [_monthlyFeeAmount, _okseMonthlyProfit, _withdrawFeePercent, newBuyFeePercent, newBuyTxFee])
    let { v, r, s, keys } = await getSignKeys(process.env.SECOND_OWNER, contractAddress, chainId, signData);
    console.log(signData, keys);
    const tx = await multiSigContract.ssetFeeValues(signData, keys);
    console.log("--- tx = ", tx);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });