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

## flatten contract

    yarn flatten contracts/OkseCard.sol > flattened/OkseCard.sol

## Deployed contracts address and size

    ·-------------------------------|-------------|---------------·····························|
    |  Contract Name                ·  Size (KB)  ·                 ftm  address               │
    ································|·············|············································|
    |  CashBackManager              ·      4.228  · 0xe2DE49356D55bBC1D56AA57099FFdbE1868B427A │
    ································|·············|············································|
    |  Converter                    ·      1.622  · 0x515695578eECd92d7747897df7756967912E678a │
    ································|·············|············································|
    |  LevelManager                 ·      6.318  · 0x22CAe3f82c6b8AAA2457175fD6A788aA2940bEe6 │
    ································|·············|············································|
    |  LimitManager                 ·      7.309  · 0x4cf6BB5F07966a53BB08a153e1843832c0747639 │ 
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
    |  TWAPPriceFeedManager         ·      1.184  · 0xB4A96962CBD337B4016eD16bB7c532e4e38073eC │
    ································|·············|············································|
    |  multicall2                   ·             · 0x9C8f861Ffcbe25a40018E527cE4276D223961A29 │
    ································|·············|············································|
    |  SinkCharger                  ·             · 0x2d4817A78dC8386d53a471330faADc3ce48c20e3 │
    ································|·············|············································|

    ·-------------------------------|-------------|·············································
    |  Contract Name                ·  Size (KB)  ·               bscmainnet address           │
    ································|·············|············································|
    |  CashBackManager              ·      4.228  · 0x0c123aE1cDaFbD71f9Bf8966c19081E47115b115 │
    ································|·············|············································|
    |  Converter                    ·      1.622  · 0xD962e220ED470084cC2dbF425784E8ccBCFE7Ce9 │
    ································|·············|············································|
    |  LevelManager                 ·      6.318  · 0x33d38A7E5552271768267d144B4315f451971dd6 │
    ································|·············|············································|
    |  LimitManager                 ·      7.309  · 0xfA3E7d864cf426381aF1A990FD2E19d56b03dF33 │ 
    ································|·············|············································|
    |  MarketManager                ·     10.399  · 0x4fc6321F218C1eb8E959F97bD6F918AC738e7f7c │
    ································|·············|············································|
    |  OkseCard                     ·     24.064  · 0x40F5a9Bfd79585FFe39E93Efed59b84D27d6d593 │
    ································|·············|············································|
    |  OkseCardPriceOracle          ·      6.166  · 0x515695578eECd92d7747897df7756967912E678a │
    ································|·············|············································|
    |   Swapper                     ·      4.235  · 0xde91e495d0b79f74e9cAc6c2bdcf2c07d9Aba74D │  
    ································|·············|············································|
    |  OkseToken                    ·      2.505  · 0x606FB7969fC1b5CAd58e64b12Cf827FB65eE4875 │
    ································|·············|············································|
    |  OkseCustomPriceFeed2         ·      3.407  · 0x54E53AdDDC481fEEC64656166049b8D0c1877Ec0 │
    ································|·············|············································|
    |  TWAPPriceFeedManager         ·      1.184  · 0xb81C987Fede22fF2095808713C01B61944792Db1 │
    ································|·············|············································|
    |  multicall2                   ·             · 0x41B90b73a88804f2aed1C4672b3dbA74eb9A92ce │
    ································|·············|············································|
    |  SinkCharger                  ·             · 0x8aA771e8D188799515c15794c0bE08F63588e2BF │
    ································|·············|············································|

    ·-------------------------------|-------------|·············································
    |  Contract Name                ·  Size (KB)  ·                 avaxc address              │
    ································|·············|············································|
    |  CashBackManager              ·      4.228  · 0x4fc6321F218C1eb8E959F97bD6F918AC738e7f7c │
    ································|·············|············································|
    |  Converter                    ·      1.622  · 0x08B1fC2B48e5871354AF138B7909E9d1a04A89DD │
    ································|·············|············································|
    |  LevelManager                 ·      6.318  · 0xB1152Aaf71c44a8292d550c8c077D6Fc998D9CB9 │
    ································|·············|············································|
    |  LimitManager                 ·      7.309  · 0xcbeDEe9C29E92d61adD691dE46bc6d4F4Bb070A7 │ 
    ································|·············|············································|
    |  MarketManager                ·     10.399  · 0x30342EBb1fa044A9BBFd4256973B5f551e654103 │
    ································|·············|············································|
    |  OkseCard                     ·     24.064  · 0xe47C751c72EF1d2723e021F8153567Bd3e076a70 │
    ································|·············|············································|
    |  OkseCardPriceOracle          ·      6.166  · 0x4141c9420DF74d2379c1D3CD983a8c306Aa1A6b4 │
    ································|·············|············································|
    |   Swapper                     ·      4.235  · 0x451Dc7f50f4c89e9E3356515994a8024Ac792A8e │
    ································|·············|············································|
    |  OkseToken                    ·      2.505  · 0xbc7B0223Dd16cbc679c0D04bA3F4530D76DFbA87 │
    ································|·············|············································|
    |  OkseCustomPriceFeed2         ·      3.407  · 0xC146794e568D1B4087F2D79Bf5e3fBF18Fe5Ff76 │
    ································|·············|············································|
    |  TWAPPriceFeedManager         ·      1.184  · 0x0aaBC7C5380E01Bd30e555aCa966d9C8A86751f5 │
    ································|·············|············································|
    |  multicall2                   ·             · 0x84514BeaaF8f9a4cbe25A9C5a7EBdd16B4FE7154 │
    ································|·············|············································|
    |  SinkCharger                  ·             · 0x5d121d31892DB85C49d2Cc4B88D03e9bfEa815f3 │
    ································|·············|············································|

    ·-------------------------------|-------------|·············································
    |  Contract Name                ·  Size (KB)  ·                 okex address               │
    ································|·············|············································|
    |  CashBackManager              ·      4.228  · 0xB1152Aaf71c44a8292d550c8c077D6Fc998D9CB9 │
    ································|·············|············································|
    |  Converter                    ·      1.622  · 0xB4A96962CBD337B4016eD16bB7c532e4e38073eC │
    ································|·············|············································|
    |  LevelManager                 ·      6.318  · 0x22CAe3f82c6b8AAA2457175fD6A788aA2940bEe6 │
    ································|·············|············································|
    |  LimitManager                 ·      7.309  · 0xcbeDEe9C29E92d61adD691dE46bc6d4F4Bb070A7 │ 
    ································|·············|············································|
    |  MarketManager                ·     10.399  · 0x3CE2AFD4dA06a09F8b4c5715Ff74E83EAC3633d0 │
    ································|·············|············································|
    |  OkseCard                     ·     24.064  · 0xC6ff41994413fFc01b25c47BCdDf7c9D277d6059 │
    ································|·············|············································|
    |  OkseCardPriceOracle          ·      6.166  · 0xff2a9c67993f37a8F7793EA286bFFDc57521a187 │
    ································|·············|············································|
    |   Swapper                     ·      4.235  · 0xb2c4A6b8febDCD4D56c402D7677AD5f62d36a557 │
    ································|·············|············································|
    |  OkseToken                    ·      2.505  · 0xA844C05ae51DdafA6c4d5c801DE1Ef5E6F626bEC │
    ································|·············|············································|
    |  OkseCustomPriceFeed2         ·      3.407  ·  │
    ································|·············|············································|
    |  TWAPPriceFeedManager         ·      1.184  · 0xd532E773a1233B1ca02f4fc6fcbb1988D539c274 │
    ································|·············|············································|
    |  multicall2                   ·             · 0xdf4CDd4b8F1790f62a91Bcc4cb793159c641B1bd │
    ································|·············|············································|
    |  SinkCharger                  ·             · 0x6fFfeFF12bDa57E71ce02877E46aa900E4cd1e62 │
    ································|·············|············································|

    ·-------------------------------|-------------|·············································
    |  Contract Name                ·  Size (KB)  ·             arbitrum address               │
    ································|·············|············································|
    |  CashBackManager              ·      4.228  · 0xd9Eb005a3AFE4969b9C4aE77F25De48C67c08fF0 │
    ································|·············|············································|
    |  Converter                    ·      1.622  · 0xfA3E7d864cf426381aF1A990FD2E19d56b03dF33 │
    ································|·············|············································|
    |  LevelManager                 ·      6.318  · 0x55A3032F6EA15E21151a6553CD306137f502C469 │
    ································|·············|············································|
    |  LimitManager                 ·      7.309  · 0x7c115E8a8F6e5f14897D2e2ed170acB658A0dc1d │
    ································|·············|············································|
    |  MarketManager                ·     10.399  · 0x7c3da197314eA6885F54FbF6Bee2A8e329fE88d1 │
    ································|·············|············································|
    |  OkseCard                     ·     24.064  · 0x15F7E90A0fcF6219aD80bB0bF2D62C49276Cb764 │
    ································|·············|············································|
    |  OkseCardPriceOracle          ·      6.166  · 0xcbeDEe9C29E92d61adD691dE46bc6d4F4Bb070A7 │
    ································|·············|············································|
    |   Swapper                     ·      4.235  · 0x41f5391b474bFB3688acA4ea3e6BEBD8aBE7838c │
    ································|·············|············································|
    |  OkseToken                    ·      2.505  · 0x4313DDa7bc940F3f2B2ddDACF568300165C878CA │
    ································|·············|············································|
    |  OkseCustomPriceFeed2         ·      3.407  ·  │
    ································|·············|············································|
    |  TWAPPriceFeedManager         ·      1.184  ·  │
    ································|·············|············································|
    |  multicall2                   ·             · 0x842eC2c7D803033Edf55E478F461FC547Bc54EB2 │
    ································|·············|············································|
    |  SinkCharger                  ·             ·  │
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

        Add VOLT token on bsc
            token address       0x7db5af2B9624e1b3B4Bb69D6DeBd9aD1016A58Ac
            TWAPPriceFeed2      0x536CEf7F539Ab4C71950d32b12a146bed7EDf084
        
        Add ARV token on bsc
            token address       0x6679eB24F59dFe111864AEc72B443d1Da666B360
            TWAPPriceFeed2      0x750632A9a95bf557da96203219d9aE2C98Cd0A96   
        
        add LUNA token on bsc
            token address       0x156ab3346823B651294766e23e6Cf87254d68962
            TWAPPriceFeed2      0xe2185a1ebB2303DE5B9A9776365538fcDD0D7525
        
        add DOGE token on bsc
            token address       0xbA2aE424d960c26247Dd6c32edC70B295c744C43      decimal 8
            TWAPPriceFeed2      0xcbeDEe9C29E92d61adD691dE46bc6d4F4Bb070A7
            chainlink pricefeed  0x3AB0A0d137D4F946fBB19eecc6e92E64660231C8     not set yet    
        add USTC token on bsc   0x23396cF899Ca06c4472205fC903bDB4de249D6fC
            TWAPPriceFeed       0x33fb5277D65Eaf00c88bA279e502805f5ac8bb88

        add MCRT token on BSC
            token address      0x4b8285aB433D8f69CB48d5Ad62b415ed1a221e4f
            TWAPPriceFeed2     0x7c3da197314eA6885F54FbF6Bee2A8e329fE88d1

        add TWT token on BSC
            token address      0x4b0f1812e5df2a09796481ff14017e6005508003
            TWAPPriceFeed2      0x31416EAbeF23DDB20700a342F4Dda310F3C38987  testAmount 10 ether
        add BTT token on BSC
            token address       0x352Cb5E19b12FC216548a2677bD0fce83BaE434B
            TWAPPriceFeed       0xCE9673477918e8faEcabF3d05a538f85a8329173  testAmount 10000000 ether
        add TRX token on BSC
            token address       0x85EAC5Ac2F758618dFa09bDbe0cf174e7d574D5B
            chainlink price feed  0xF4C5e535756D11994fCBB12Ba8adD0192D9b88be            

    -AVAXC

        TWAPPriceFeedManager        0x0aaBC7C5380E01Bd30e555aCa966d9C8A86751f5

        Add joe on avaxc
            token address       0x6e84a6216eA6dACC71eE8E6b0a5B7322EEbC0fDd
            pair JOE-AVAX       7M, JOE-USDC 0.9M
            chainlink price feed       0x02d35d3a8ac3e1626d3ee09a78dd87286f5e8e3a    
    -OKEX

        TWAPPriceFeedManager    0xd532E773a1233B1ca02f4fc6fcbb1988D539c274

        WOKT    TWAPPriceFeed   0x72B803Dd976E2277D8c16163703BE2cDe0E0E8D3
        USDT    TWAPPriceFeed   0x61942e306965184cD92BE58818F99EC265d62B6F
        OKSE    TWAPPriceFeed2  0xde91e495d0b79f74e9cAc6c2bdcf2c07d9Aba74D

    -ETH
        
    StableCoinConverter  on BSC   0x537DCd1dDa4f5373bf2BCbBb38f48561309421de
        exchanger = "0x19609B03C976CCA288fbDae5c21d4290e9a4aDD7";
        token = "0xe9e7cea3dedca5984780bafc599bd69add087d56";
        usdc = "0x8ac76a51cc950d9822d68b83fe1ad97b32cd580d";
        bridge = "0xdd90e5e87a2081dcf0391920868ebc2ffb81a1af";
        usdcPool = "0x312bc7eaaf93f1c60dc5afc115fccde161055fb0";

    - Arbitrum
      - markets WETH, USDC, OKSE
      - price feed   weth   	0x82af49447d8a07e3bd95bd0d56f35241523fbab1  0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612
                     usdc       0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8  0x50834F3163758fcC1Df9973b6e91f0F0F0434aD3
                     okse       0x4313DDa7bc940F3f2B2ddDACF568300165C878CA

   