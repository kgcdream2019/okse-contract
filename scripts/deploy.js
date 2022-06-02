// This is a script for deploying your contracts. You can adapt it to deploy

const { ethers } = require("hardhat");

// yours, or create new ones.
async function main() {
  // This is just a convenience check
  if (network.name === "hardhat") {
    console.warn(
      "You are trying to deploy a contract to the Hardhat Network, which" +
        "gets automatically created and destroyed every time. Use the Hardhat" +
        " option '--network localhost'"
    );
  }

  // ethers is avaialble in the global scope
  const [deployer] = await ethers.getSigners();
  console.log(
    "Deploying the contracts with the account:",
    await deployer.getAddress()
  );

  console.log("Account balance:", (await deployer.getBalance()).toString());
  const OkseCardPriceOracle = await ethers.getContractFactory("OkseCardPriceOracle");
  const priceOracle = await OkseCardPriceOracle.deploy();
  await priceOracle.deployed();
  console.log("OkseCardPriceOracle address:", priceOracle.address);


  //address _WETH, address _USDT, address _okseAddress, address _priceOracle, address _factory
  const _WETH ="0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270";  // WMATIC
  const USDT = "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174";  // USDC
  const okse = "0x049f12F5a27132d06DE128D48a914F6D82D33D23";  // OKSE
  const factory = "0xc35DADB65012eC5796536bD9864eD8773aBc74C4"; // sushiswap factory
  
  //matic network constants
  const OkseCard = await ethers.getContractFactory("OkseCard");
  const oksecard = await OkseCard.deploy(_WETH, USDT, okse, priceOracle.address, factory);
  await oksecard.deployed();
  console.log("OkseCard address:", oksecard.address);

  const oksecardContract = await ethers.getContractAt("OkseCard", oksecard.address);
  await oksecardContract.addMarket(_WETH);
  console.log("WMATIC market is added market address = ", _WETH);
  await oksecardContract.addMarket(USDT);
  console.log("USDT market is added market address = ", USDT);
  await oksecardContract.addMarket(okse);
  console.log("okse market is added market address = ", okse);
  
  const financialAddress = "0x8D6963fbc2a203a91f7011718e27e11c2E87D634";
  const treasuryAddress  = "0x23BaDd10261c02aA6CB1a90114daE41265B4F221";
  const masterAddress    = "0x68249d7F891EA6E3142DF4801891Dd10e2E22FFe";

  console.log('Set financial address = ', financialAddress);
  await oksecardContract.setFinancialAddress(financialAddress);
  console.log('Set treasury  address = ', treasuryAddress);
  await oksecardContract.setTreasuryAddress(treasuryAddress);
  console.log('Set master  address = ', masterAddress);
  await oksecardContract.setMasterAddress(masterAddress); 
  

 

  // We also save the contract's artifacts and address in the frontend directory
  saveFrontendFiles(oksecard);

}

function saveFrontendFiles(oksecard) {
  const fs = require("fs");
  const contractsDir = __dirname + "/../frontend/src/contracts";

  if (!fs.existsSync(contractsDir)) {
    fs.mkdirSync(contractsDir);
  }

  fs.writeFileSync(
    contractsDir + "/contract-address.json",
    JSON.stringify({ OkseCard: oksecard.address }, undefined, 2)
  );

  const OkseCardArtifact = artifacts.readArtifactSync("OkseCard");

  fs.writeFileSync(
    contractsDir + "/OkseCard.json",
    JSON.stringify(OkseCardArtifact, null, 2)
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
