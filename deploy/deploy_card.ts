import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts, network, ethers } = hre;
  const chainId = parseInt(await hre.getChainId(), 10);
  const skipIfAlreadyDeployed = chainId === 324 || chainId === 280
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
  // let _owners = [
  //   "0x11314C0b1bB3844eB43fF05D1E877d36cC1A134b",
  //   "0x09b2aFF4A268E40EdC9D3A0695339c3E9B84df9e",
  //   "0xba6BA085F0B6BE8f8A2D0f5a4F450c407fDC5aa4",
  // ];
  // owners from tobias
  let _owners = [
    "0x11314C0b1bB3844eB43fF05D1E877d36cC1A134b",
    "0xC533335b07e4E6B79763AAa65D45AF2c0606a016",
    "0x3Cdf6195e83a61e9D1842c70707e7B2fe10D2793",
  ];
  let _ownersForPriceOracle = [
    "0xba6BA085F0B6BE8f8A2D0f5a4F450c407fDC5aa4",
    "0x11314C0b1bB3844eB43fF05D1E877d36cC1A134b",
    "0x09b2aFF4A268E40EdC9D3A0695339c3E9B84df9e",
  ];
  const oksecardPriceOracle = await deploy("OkseCardPriceOracle", {
    from: deployer,
    args: [],
    log: true,
    skipIfAlreadyDeployed
  });
  await initializeOwners(
    "OkseCardPriceOracle",
    oksecardPriceOracle.address,
    _ownersForPriceOracle
  );

  // address _WETH, address _USDT, address _okseAddress, address _priceOracle, address _factory
  let _WETH: string; // WETH
  let USDT: string; // USDC
  let okse: string; // OKSE
  let factory: string; // factory

  let swapper: any;
  if (network.name === "fantom") {
    _WETH = "0x21be370D5312f44cB42ce377BC9b8a0cEF1A4C83"; // WMATIC
    USDT = "0x04068DA6C83AFCFA0e13ba15A6696662335D5B75"; // USDC
    okse = "0x3b53D2C7B44d40BE05Fa5E2309FFeB6eB2492d88"; // OKSE
    factory = "0x152eE697f2E276fA89E96742e9bB9aB1F2E61bE3"; // spookyswap factory
    swapper = await deploy("SpookySwapper", {
      from: deployer,
      args: [factory],
      log: true,
    });
  }
  if (network.name === "bscmainnet") {
    _WETH = "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c"; // WBNB
    USDT = "0x55d398326f99059fF775485246999027B3197955"; // USDT
    okse = "0x606FB7969fC1b5CAd58e64b12Cf827FB65eE4875"; // OKSE
    factory = "0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73"; // pancakeswap factory
    swapper = await deploy("PancakeSwapper", {
      from: deployer,
      args: [factory],
      log: true,
    });
  }
  if (network.name === "avaxc") {
    _WETH = "0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7"; // WAVAX
    USDT = "0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E"; // USDC
    okse = "0xbc7B0223Dd16cbc679c0D04bA3F4530D76DFbA87"; // OKSE
    factory = "0x9Ad6C38BE94206cA50bb0d90783181662f0Cfa10"; // traderjoe factory
    swapper = await deploy("TraderJoeSwapper", {
      from: deployer,
      args: [factory],
      log: true,
    });
  }
  if (network.name === "okex") {
    _WETH = "0x8f8526dbfd6e38e3d8307702ca8469bae6c56c15"; // WOKT
    USDT = "0x382bb369d343125bfb2117af9c149795c6c65c50"; // USDT
    okse = "0xA844C05ae51DdafA6c4d5c801DE1Ef5E6F626bEC"; // OKSE
    factory = "0x709102921812B3276A65092Fe79eDfc76c4D4AFe"; // cherryswap factory
    swapper = await deploy("CherrySwapper", {
      from: deployer,
      args: [factory],
      log: true,
    });
  }
  if (network.name === "arbitrum") {
    _WETH = "0x82af49447d8a07e3bd95bd0d56f35241523fbab1"; // WETH
    USDT = "0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9"; // USDT
    okse = "0x4313DDa7bc940F3f2B2ddDACF568300165C878CA"; // OKSE
    const router = "0xE592427A0AEce92De3Edee1F18E0157C05861564"; // uniswap v3 abitrum router
    swapper = await deploy("UniswapV3Swapper", {
      from: deployer,
      args: [router, oksecardPriceOracle.address, _WETH, USDT],
      log: true,
    });
  }
  if (network.name === "polygon") {
    _WETH = "0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270"; // WMATIC
    USDT = "0xc2132D05D31c914a87C6611C10748AEb04B58e8F"; // USDC
    okse = "0xFf1674D39dEf5d3840f4021FAD2c5D4F20520557"; // OKSE
    factory = "0x5757371414417b8C6CAad45bAeF941aBc7d3Ab32"; // quickswap factory
    swapper = await deploy("QuickSwapper", {
      from: deployer,
      args: [factory],
      log: true,
    });
  }
  if (network.name === "optimism") {
    _WETH = "0x4200000000000000000000000000000000000006"; // WETH
    USDT = "0x94b008aA00579c1307B0EF2c499aD98a8ce58e58"; // USDC
    okse = "0x259479fBeb1CDe194afA297f36f4216e9C87728c"; // OKSE
    const router = "0xE592427A0AEce92De3Edee1F18E0157C05861564"; // uniswap v3 router 02
    swapper = await deploy("UniswapV3Swapper", {
      from: deployer,
      args: [router, oksecardPriceOracle.address, _WETH, USDT],
      log: true,
    });
  }
  if (network.name === "zksyncMainnet") {
    _WETH = "0x5AEa5775959fBC2557Cc8789bC1bf90A239D9a91"; // WETH
    USDT = "0x3355df6D4c9C3035724Fd0e3914dE96A5a83aaf4"; // USDC
    okse = "0x8483bf6d5E45e467f2979c5d51B76100AAB60294"; // OKSE
    const classicFactory = "0xf2DAd89f2788a8CD54625C60b55cD3d2D0ACa7Cb"; // cherryswap factory
    const stableFactory = "0x5b9f21d407F35b10CbfDDca17D5D84b129356ea3"; // cherryswap factory
    const vault = "0x621425a1Ef6abE91058E9712575dcc4258F8d091"; // cherryswap factory

    swapper = await deploy("SyncSwapper", {
      from: deployer,
      args: [classicFactory, stableFactory, vault],
      log: true,
      skipIfAlreadyDeployed
    });
  }
  if (network.name === "mainnet") {
    _WETH = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"; // WETH
    USDT = "0xdAC17F958D2ee523a2206206994597C13D831ec7";  // USDT
    okse = "0x683be00CCa798D59bfBc58C818CbC7C72bE947DC";  // OKSE
    const router = "0xE592427A0AEce92De3Edee1F18E0157C05861564"; // uniswap v3 router 02
    swapper = await deploy("UniswapV3Swapper", {
      from: deployer,
      args: [router, oksecardPriceOracle.address, _WETH, USDT],
      log: true,
    });
  }
  const Converter_Implementation = await deploy("Converter", {
    from: deployer,
    args: [],
    log: true,
    skipIfAlreadyDeployed
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
    skipIfAlreadyDeployed
  });
  await initializeOwners("OkseCard", OkseCard_Implementation.address, _owners);
  const okseCardAddress = OkseCard_Implementation.address;
  // LevelManager
  const LevelManager_Implementation = await deploy("LevelManager", {
    from: deployer,
    args: [okseCardAddress],
    log: true,
    skipIfAlreadyDeployed
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
    skipIfAlreadyDeployed
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
    skipIfAlreadyDeployed
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
    skipIfAlreadyDeployed
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
  // const governorAddress = "0xCBd4e556fC24C83159DEfD1D1BBAd66Fd7d2C75c";
  const governorAddress = "0x24Bd16b990F3A376712f4FCE6C5fCB05A3db3745";
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
