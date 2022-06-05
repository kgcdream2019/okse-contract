const { ethers, } = require('ethers');
const ethUtil = require('ethereumjs-util');
const { splitSignature } = require("@ethersproject/bytes");

const getFunctionSignature = (functionString) => {
    // functionString = 'payMonthlyFee(uint256,address,uint256,uint8,bytes32,bytes32)'
    const abi = [`function ${functionString}`]
    const interface = new ethers.utils.Interface(abi)
    const defaultValue = ethers.utils.defaultAbiCoder.getDefaultValue(
        ethers.utils.FunctionFragment.from(functionString).inputs
    )
    const funcSig = (interface.encodeFunctionData(functionString, defaultValue))
        .substr(0, 10);
    return funcSig
}

const getEncodedString = (messageText) => {
    return ethers.utils
        .keccak256(ethers.utils.defaultAbiCoder.encode(['string'], [messageText]))
        .slice(2)
}

const getEncodedBytes = (messageText) => {
    return ethers.utils.arrayify(messageText)
}

const getEncodedContractKeccak = (typeArray, dataArray) => {
    // typeArray: ["address", "bytes4", "uint256", "address", "address", "uint256", "uint256"]
    // dataArray: [contractAddress, method, apiId, userAddress, marketAddress, amount, validTime]
    const messageHash = ethers.utils.solidityKeccak256(typeArray, dataArray);
    return getEncodedBytes(messageHash)
}

const getPureSignerAddress = (signMessage, signSignature) => {
    const sig = splitSignature(signSignature)
    const signerAddress = ethers.utils.verifyMessage(signMessage, sig)
    return signerAddress
}

const getStringSignerAddress = (messageText, signSignature) => {
    const signMessage = getEncodedString(messageText)
    const signerAddress = getPureSignerAddress(signMessage, signSignature)
    return signerAddress
}

const getBytesSignerAddress = (messageText, signSignature) => {
    const signMessage = getEncodedBytes(messageText)
    const signerAddress = getPureSignerAddress(signMessage, signSignature)
    return signerAddress
}

const getContractSignerAddress = (typeArray, dataArray, signSignature) => {
    const signMessage = getEncodedContractKeccak(typeArray, dataArray)
    const signerAddress = getPureSignerAddress(signMessage, signSignature)
    return signerAddress
}

const performPureSign = async (privateKey, messageText) => {
    return new Promise(async (resolve, reject) => {
        try {
            const backendSigner = new ethers.Wallet(privateKey);
            const signMessage = messageText
            const signSignature = await backendSigner.signMessage(signMessage)
            const signerAddress = getPureSignerAddress(messageText, signSignature)
            console.log(' --- signerAddress', signerAddress)
            resolve(signSignature)
        } catch (error) {
            reject(error)
        }
    })
}

const performStringSign = async (privateKey, messageText) => {
    return new Promise(async (resolve, reject) => {
        try {
            const backendSigner = new ethers.Wallet(privateKey);
            const signMessage = getEncodedString(messageText)
            const signSignature = await backendSigner.signMessage(signMessage)
            const signerAddress = getStringSignerAddress(messageText, signSignature)
            console.log(' --- signerAddress', signerAddress)
            resolve(signSignature)
        } catch (error) {
            reject(error)
        }
    })
}

const performBytesSign = async (privateKey, messageText) => {
    return new Promise(async (resolve, reject) => {
        try {
            const backendSigner = new ethers.Wallet(privateKey);
            const signMessage = getEncodedBytes(messageText)
            const signSignature = await backendSigner.signMessage(signMessage)
            const signerAddress = getBytesSignerAddress(messageText, signSignature)
            console.log(' --- signerAddress', signerAddress)
            resolve(signSignature)
        } catch (error) {
            reject(error)
        }
    })
}

const performContractSign = async (privateKey, contractAddress, method, apiId, userAddress, marketAddress, amount, validTime) => {
    return new Promise(async (resolve, reject) => {
        try {
            const typeArray = ["address", "bytes4", "uint256", "address", "address", "uint256", "uint256"]
            const dataArray = [contractAddress, method, apiId, userAddress, marketAddress, amount, validTime]

            const backendSigner = new ethers.Wallet(privateKey);
            const signMessage = getEncodedContractKeccak(typeArray, dataArray);

            const signSignature = await backendSigner.signMessage(signMessage)

            const signerAddress = getContractSignerAddress(typeArray, dataArray, signSignature)
            console.log(' --- signerAddress', signerAddress)

            const { v, r, s } = splitSignature(signSignature)

            resolve({
                method, id: apiId, userAddress, marketAddress, amount, validTime,
                v, r, s, relayer: signerAddress, signMessage, signSignature
            })
        } catch (error) {
            reject(error)
        }
    })
}
// MultiSig Owner
function getId(str) {
    return `0x${ethUtil.keccak256(str).toString("hex").substring(0, 8)}`;
}

const getSignData = (functionName, id, typeArray, dataArray) => {
    // typeArray: ["address", "bytes4", "uint256", "address", "address", "uint256", "uint256"]
    // dataArray: [contractAddress, method, apiId, userAddress, marketAddress, amount, validTime]
    let params = ethers.utils.defaultAbiCoder.encode(typeArray, dataArray);
    let funcSig = getId(functionName);
    var current = new Date();
    let signValidTime = Math.floor(current.getTime() / 1000 + 86400);
    let signData = ethers.utils.defaultAbiCoder.encode(["bytes4", "uint256", "uint256", "bytes"], [funcSig, id, signValidTime, params])
    return signData
}
const getSignKeys = async (privateKey, contractAddress, chainId, signData) => {
    return new Promise(async (resolve, reject) => {
        try {
            const typeArray = ["address", "uint256", "bytes"]
            const dataArray = [contractAddress, chainId, signData]

            const backendSigner = new ethers.Wallet(privateKey);
            const signMessage = getEncodedContractKeccak(typeArray, dataArray);

            const signSignature = await backendSigner.signMessage(signMessage)

            const signerAddress = getContractSignerAddress(typeArray, dataArray, signSignature)
            console.log(' --- signerAddress', signerAddress)

            const { v, r, s } = splitSignature(signSignature)
            let keys = ethers.utils.defaultAbiCoder.encode(["uint8", "bytes32", "bytes32"], [v, r, s]);
            resolve({
                v, r, s, keys
            })
        } catch (error) {
            reject(error)
        }
    })
}
module.exports = {
    splitSignature,
    getFunctionSignature,

    getPureSignerAddress,
    getStringSignerAddress,
    getBytesSignerAddress,
    getContractSignerAddress,

    performPureSign,
    performStringSign,
    performBytesSign,
    performContractSign,

    getSignData,
    getSignKeys

};
