const _owner = "0x11314C0b1bB3844eB43fF05D1E877d36cC1A134b";

const _priceOracle = "0x465523a04d0E733ee366e37aC5f1A81468dF8023";
const financialAddress = "0x8D6963fbc2a203a91f7011718e27e11c2E87D634";
const masterAddress    = "0x68249d7F891EA6E3142DF4801891Dd10e2E22FFe";
const treasuryAddress  = "0x23BaDd10261c02aA6CB1a90114daE41265B4F221";
// const _governorAddress = "0xA7430e1F71C44ce7fd2cec296F946cf0f126A549"; // real governance adderss
const _governorAddress = "0x11314C0b1bB3844eB43fF05D1E877d36cC1A134b";
// const _swapper = "0x9bF5efaF5A3Ea1585C491F3AD900ED046e7cE2B9"; // sushiswapper 
const _swapper = "0x536CEf7F539Ab4C71950d32b12a146bed7EDf084"; // spookyswapper 
const _monthlyFeeAddress = "0x6A17F7CA4cFc77b8bA77c6b9279e676397332b00";
const _stakeContractAddress = "0x425FE9f23DC4453237B4427f07ba45B58bB0bbEa";
const j2 = await ethers.getContractAt("OkseCardV2", "0x06C2b8a2C6c7CA054c2e343b199A5458FdfB1dBf");
// address _priceOracle,
// address _financialAddress,
// address _masterAddress,
// address _treasuryAddress,
// address _governorAddress,
// address _monthlyFeeAddress,
// address _stakeContractAddress,
// address _swapper
await j2.initialize(_priceOracle, financialAddress, masterAddress, treasuryAddress, _governorAddress,_monthlyFeeAddress, _stakeContractAddress, _swapper);