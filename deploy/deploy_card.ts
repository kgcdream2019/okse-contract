import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts, network, ethers } = hre;
  async function initializeOwners(
    contractName: string,
    contractAddress: string,
    _owners: string[]
  ) {
    try {
      let contract = await ethers.getContractAt(contractName, contractAddress);
      const txPure = await contract.initializeOwners(_owners);
      const sendTx = await txPure.wait();
      console.log(
        `${contractName} initializeOwners txHash = ${sendTx.transactionHash}`
      );
    } catch (e) {
      console.log(e.message);
    }
  }
  const { deploy } = deployments;
  // console.log(network);
  const { deployer } = await getNamedAccounts();
  let _owners = [
    "0xF92d6d2c833434EF1Cc9284f9890A17d42497CCB",
    "0x11314C0b1bB3844eB43fF05D1E877d36cC1A134b",
    "0x0Ed78A9DE439d4aA69596402A0947819655d3c05",
  ];
  // owners from tobias
  // let _owners = [
  //   "0xF92d6d2c833434EF1Cc9284f9890A17d42497CCB",
  //   "0xC533335b07e4E6B79763AAa65D45AF2c0606a016",
  //   "0x3Cdf6195e83a61e9D1842c70707e7B2fe10D2793",
  // ];
  let _ownersForPriceOracle = [
    "0xF92d6d2c833434EF1Cc9284f9890A17d42497CCB",
    "0x11314C0b1bB3844eB43fF05D1E877d36cC1A134b",
    "0x0Ed78A9DE439d4aA69596402A0947819655d3c05",
  ];
  const oksecardPriceOracle = await deploy("OkseCardPriceOracle", {
    from: deployer,
    args: [],
    log: true,
  });
  await initializeOwners(
    "OkseCardPriceOracle",
    oksecardPriceOracle.address,
    _ownersForPriceOracle
  );

  // address _WETH, address _USDT, address _okseAddress, address _priceOracle, address _factory
  var _WETH: string; // WMATIC
  var USDT: string; // USDC
  var okse: string; // OKSE
  var factory: string; // sushiswap factory

  let swapper: any;
  if (network.name === "fantom") {
    _WETH = "0x21be370D5312f44cB42ce377BC9b8a0cEF1A4C83"; // WMATIC
    USDT = "0x04068DA6C83AFCFA0e13ba15A6696662335D5B75";  // USDC
    okse = "0x3b53D2C7B44d40BE05Fa5E2309FFeB6eB2492d88";  // OKSE
    factory = "0x152eE697f2E276fA89E96742e9bB9aB1F2E61bE3"; // spookyswap factory
    swapper = await deploy("SpookySwapper", {
      from: deployer,
      args: [factory],
      log: true,
    });
  }
  if (network.name === "bscmainnet") {
    _WETH = "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c"; // WBNB
    USDT = "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56";  // BUSD
    okse = "0x606FB7969fC1b5CAd58e64b12Cf827FB65eE4875";  // OKSE / SPIRIT
    factory = "0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73"; // pancakeswap factory
    swapper = await deploy("PancakeSwapper", {
      from: deployer,
      args: [factory],
      log: true,
    });
  }
  const Converter_Implementation = await deploy("Converter", {
    from: deployer,
    args: [],
    log: true,
  });

  const signer = "0x5126EA3894671E1c6cce47D3fB462E3C270e499e";

  // // const oksecard = await deploy('OkseCard', {
  // //     from: deployer,
  // //     args: [_WETH, USDT, okse],
  // //     libraries: {

  // //     },
  // //     proxy: {
  // //       owner: deployer,
  // //       proxyContract: 'OpenZeppelinTransparentProxy',
  // //       viaAdminContract: 'DefaultProxyAdmin',
  // //     },
  // //     log: true,
  // //   })
  // //   console.log("oksecard address = ", oksecard.address);

  // const DefaultProxyAdmin = await deploy('ProxyAdmin', {
  //   from: deployer,
  //   args: [],
  //   log: true,
  // })

  const OkseCard_Implementation = await deploy("OkseCard", {
    from: deployer,
    args: [Converter_Implementation.address, signer],
    log: true,
  });
  await initializeOwners("OkseCard", OkseCard_Implementation.address, _owners);
  const okseCardAddress = OkseCard_Implementation.address;
  // LevelManager
  const LevelManager_Implementation = await deploy("LevelManager", {
    from: deployer,
    args: [okseCardAddress],
    log: true,
  });
  await initializeOwners(
    "LevelManager",
    LevelManager_Implementation.address,
    _owners
  );
  // LimitManager
  const LimitManager_Implementation = await deploy("LimitManager", {
    from: deployer,
    args: [okseCardAddress, LevelManager_Implementation.address],
    log: true,
  });
  await initializeOwners(
    "LimitManager",
    LimitManager_Implementation.address,
    _owners
  );
  // MarketManager
  const MarketManager_Implementation = await deploy("MarketManager", {
    from: deployer,
    args: [
      okseCardAddress,
      _WETH,
      USDT,
      okse,
      Converter_Implementation.address,
    ],
    log: true,
  });
  await initializeOwners(
    "MarketManager",
    MarketManager_Implementation.address,
    _owners
  );
  // CashBackManager
  const CashBackManager_Implementation = await deploy("CashBackManager", {
    from: deployer,
    args: [okseCardAddress],
    log: true,
  });
  await initializeOwners(
    "CashBackManager",
    CashBackManager_Implementation.address,
    _owners
  );

  // initialize Card contract
  let okseCardContract = await ethers.getContractAt(
    "OkseCard",
    okseCardAddress
  );
  const financialAddress = "0x700B4A3F6bf15D7E31a87fBFB1A4bBba9Bf8EB87";
  const masterAddress = "0xCe75aaeEfef7b14cE7156d800B291b195559d07c";
  const treasuryAddress = "0xf57F68e6bc75979feB128C1A2061EeD60695f190";
  const governorAddress = "0xCBd4e556fC24C83159DEfD1D1BBAd66Fd7d2C75c";
  const monthlyfeeAddress = "0x7D2D43B0FB877a08ecBb8f95E01E9a70321C4c84";
  const stakeContractAddress = "0xf57F68e6bc75979feB128C1A2061EeD60695f190";
  try {
    const txPure = await okseCardContract.initialize(
      oksecardPriceOracle.address,
      LimitManager_Implementation.address,
      LevelManager_Implementation.address,
      MarketManager_Implementation.address,
      CashBackManager_Implementation.address,
      financialAddress,
      masterAddress,
      treasuryAddress,
      governorAddress,
      monthlyfeeAddress,
      stakeContractAddress,
      swapper.address
    );
    const sendTx = await txPure.wait();
    console.log("OkseCard init txHash = ", sendTx.transactionHash);
  } catch (e) {
    console.log(e.message);
  }
  // const OkseCard_Proxy = await deploy('TransparentUpgradeableProxy',{
  //   from: deployer,
  //   args: [OkseCard_Implementation.address, DefaultProxyAdmin.address,'0x'],
  //   log: true,
  // })
  // // console.log("OkseCard_Proxy = ", OkseCard_Proxy.address);
};

export default func;
func.tags = ["OkseCard"];
