# oksecard-contracts

## run scripts

    yarn start --network fantom ./scripts/PriceOracle/setDirectPrice.js

## deploy

    yarn deploy --network fantom --tags OkseCard

## deploy from scratch

    yarn deploy --network fantom --tags OkseCard --reset

## verify contract

    yarn verify --network fantom <contract address> [<constructor param>, <>,...]

## debug contract

    yarn console --network fantom
    > let j = await ethers.getContractAt("TWAPPriceFeed", "0xD7e58aCfEA8cd55AA4A19770b9a866f34a085848");
    > let r = await j.latestRoundData();
    > r = await j.setTwapEnable(true);


## Deployed contracts address and size

    ·-------------------------------|-------------|---------------·····························|
    |  Contract Name                ·  Size (KB)  ·                 ftm  address               │
    ································|·············|············································|
    |  CashBackManager              ·      4.228  · 0xe2DE49356D55bBC1D56AA57099FFdbE1868B427A │
    ································|·············|············································|
    |  Converter                    ·      1.622  · 0x515695578eECd92d7747897df7756967912E678a │
    ································|·············|············································|
    |  LevelManager                 ·      6.318  · 0xD962e220ED470084cC2dbF425784E8ccBCFE7Ce9 │
    ································|·············|············································|
    |  LimitManager                 ·      7.309  · 0x682C09d078f52Ae34Df2fA38EDf0BfB158d332d4 │
    ································|·············|············································|
    |  MarketManager                ·     10.399  · 0xC71438f3b31D133ff79F5Ad3ff5C0C0aF9AA4835 │
    ································|·············|············································|
    |  OkseCard                     ·     24.064  · 0x08B1fC2B48e5871354AF138B7909E9d1a04A89DD │
    ································|·············|············································|
    |  OkseCardPriceOracle          ·      6.166  · 0x606FB7969fC1b5CAd58e64b12Cf827FB65eE4875 │
    ································|·············|············································|
    |   Swapper                     ·      4.235  · 0x75A35B5216cbEfE2AF2b3E868bb979A482c90f78 │
    ································|·············|············································|
    |  OkseToken                    ·      2.505  · 0x3b53D2C7B44d40BE05Fa5E2309FFeB6eB2492d88 │
    ································|·············|············································|
    |  OkseCustomPriceFeed2         ·      3.407  · 0xf8dFF85007bbA10B01cDB2e8F58E84654383EE48 │
    ································|·············|············································|

    ·-------------------------------|-------------|·············································
    |  Contract Name                ·  Size (KB)  ·               bscmainnet address           │
    ································|·············|············································|
    |  CashBackManager              ·      4.228  · 0x0c123aE1cDaFbD71f9Bf8966c19081E47115b115 │
    ································|·············|············································|
    |  Converter                    ·      1.622  · 0xD962e220ED470084cC2dbF425784E8ccBCFE7Ce9 │
    ································|·············|············································|
    |  LevelManager                 ·      6.318  · 0x25994d5f8b7984AfDEb8c935B0b12CA8a6956D37 │
    ································|·············|············································|
    |  LimitManager                 ·      7.309  · 0x9666657d324F866DA07E418C91628Fd399088f37 │
    ································|·············|············································|
    |  MarketManager                ·     10.399  · 0x4fc6321F218C1eb8E959F97bD6F918AC738e7f7c │
    ································|·············|············································|
    |  OkseCard                     ·     24.064  · 0x40F5a9Bfd79585FFe39E93Efed59b84D27d6d593 │
    ································|·············|············································|
    |  OkseCardPriceOracle          ·      6.166  · 0x515695578eECd92d7747897df7756967912E678a │
    ································|·············|············································|
    |   Swapper                     ·      4.235  · 0x0aaBC7C5380E01Bd30e555aCa966d9C8A86751f5 │
    ································|·············|············································|
    |  OkseToken                    ·      2.505  · 0x606FB7969fC1b5CAd58e64b12Cf827FB65eE4875 │
    ································|·············|············································|
    |  OkseCustomPriceFeed2         ·      3.407  · 0x54E53AdDDC481fEEC64656166049b8D0c1877Ec0 │
    ································|·············|············································|

    ·-------------------------------|-------------|·············································
    |  Contract Name                ·  Size (KB)  ·                 avaxc address              │
    ································|·············|············································|
    |  CashBackManager              ·      4.228  · 0x4fc6321F218C1eb8E959F97bD6F918AC738e7f7c │
    ································|·············|············································|
    |  Converter                    ·      1.622  · 0x08B1fC2B48e5871354AF138B7909E9d1a04A89DD │
    ································|·············|············································|
    |  LevelManager                 ·      6.318  · 0x40F5a9Bfd79585FFe39E93Efed59b84D27d6d593 │
    ································|·············|············································|
    |  LimitManager                 ·      7.309  · 0x25994d5f8b7984AfDEb8c935B0b12CA8a6956D37 │
    ································|·············|············································|
    |  MarketManager                ·     10.399  · 0x30342EBb1fa044A9BBFd4256973B5f551e654103 │
    ································|·············|············································|
    |  OkseCard                     ·     24.064  · 0xe47C751c72EF1d2723e021F8153567Bd3e076a70 │
    ································|·············|············································|
    |  OkseCardPriceOracle          ·      6.166  · 0x4141c9420DF74d2379c1D3CD983a8c306Aa1A6b4 │
    ································|·············|············································|
    |   Swapper                     ·      4.235  · 0x515695578eECd92d7747897df7756967912E678a │
    ································|·············|············································|
    |  OkseToken                    ·      2.505  · 0xbc7B0223Dd16cbc679c0D04bA3F4530D76DFbA87 │
    ································|·············|············································|
    |  OkseCustomPriceFeed2         ·      3.407  · 0xC146794e568D1B4087F2D79Bf5e3fBF18Fe5Ff76 │
    ································|·············|············································|

## Add market
    - fantom
        
    - bscmainnet

Daily limits


● Stake 0 Okse - Limit $250 per Day
● Stake 5,000 Okse - Limit $500 per Day
● Stake 25,000 Okse - Limit $2,500 per Day
● Stake 50,000 Okse - Limit $5,000 per Day
● Stake 100,000 Okse - Limit $10,000 per Day
● Stake 250,000 Okse - Limit $50,000 per Day

## TWAP Price Oracle Feeds

    -fantom

    TWAPPriceFeedManager    0xB4A96962CBD337B4016eD16bB7c532e4e38073eC

    TWAPPriceFeed   MAI 0xfb98b335551a418cd0737375a2ea0ded62ea213b  0xE91DE865117EFAFfCC4dAD5673B0b12f6168511c
    TWAPPriceFeed2  okse 0x3b53D2C7B44d40BE05Fa5E2309FFeB6eB2492d88  0x0aaBC7C5380E01Bd30e555aCa966d9C8A86751f5  -- not configured
    TWAPPriceFeed2  BOO 0x841fad6eae12c286d1fd18d1d525dffa75c7effe  0xff2a9c67993f37a8F7793EA286bFFDc57521a187
    TWAPPriceFeed2  TOR 0x74E23dF9110Aa9eA0b6ff2fAEE01e740CA1c642e  0x6BF463087c8A20Ae5F983aE2109656caBE0772Dc
    TWAPPriceFeed2  JulD 0xeff6fcfbc2383857dd66ddf57efffc00d58b7d9d  0xE7C22B2de57C3297419194256EDb73808F6f62d8
    TWAPPriceFeed2  TOMB 0x6c021Ae822BEa943b2E66552bDe1D2696a53fbB7  0x97F8a06AE892d10c3BB1058F0eccfB81195Df1e4
        
    -bsc

        TWAPPriceFeedManager    0xb81C987Fede22fF2095808713C01B61944792Db1

        Add TOR token on BSC
            token address 0x1d6cbdc6b29c6afbae65444a1f65ba9252b8ca83
            TwapPriceFeed   0xff2a9c67993f37a8F7793EA286bFFDc57521a187

        Add SHIB on BSC
            token address       0x2859e4544C4bB03966803b044A93563Bd2D0DD4D
            pancakeswapper      0x80e579540Bd73a59dA93c883Fb0a96d8Fb7a19A9
            TWAPPriceFeed2		0x3BE94aD5dDB81119ab88B1771f579C2D7a44A7f3

        Add HAY (Hay Stablecoin) on BSC    
            token address       0x0782b6d8c4551B9760e74c0545a9bCD90bdc41E5
            pair Hay-BUSD
            TWAPPriceFeed           0xf185EbbB4661eFf878e03af42A20D5e69BBE070c

        Add Wombat Token(WOM) on bsc       
            token address       0xad6742a35fb341a9cc6ad674738dd8da98b94fb1
            pair    WOM-BUSD
            TWAPPriceFeed       0xeEEe4D6465d2D5A341340f5dcD7fD0c379056Fe6
        
        OKSE on BSC
            token address       0x606FB7969fC1b5CAd58e64b12Cf827FB65eE4875
            TWAPPriceFeed2      0x166088f58ca5A527F9C39E287Ee154bC0746140d
    
    -AVAXC

        TWAPPriceFeedManager        0x0aaBC7C5380E01Bd30e555aCa966d9C8A86751f5

        Add joe on avaxc
            token address       0x6e84a6216eA6dACC71eE8E6b0a5B7322EEbC0fDd
            pair JOE-AVAX       7M, JOE-USDC 0.9M
            chainlink price feed       0x02d35d3a8ac3e1626d3ee09a78dd87286f5e8e3a    