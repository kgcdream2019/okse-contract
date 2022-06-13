# oksecard-contracts

## run scripts

    yarn start --network fantom ./scripts/PriceOracle/setDirectPrice.js

## deploy

    yarn deploy --network fantom --tags OkseCard

## deploy from scratch

    yarn deploy --network fantom --tags OkseCard --reset

## verify contract

    yarn verify --network fantom <contract address> [<constructor param>, <>,...]

## Deployed contracts address and size

    ·-------------------------------|-------------|---------------·····························|·············································
    |  Contract Name                ·  Size (KB)  ·          bscmainnet  address               │               fantom address               │
    ································|·············|············································|·············································
    |  CashBackManager              ·      4.099  · 0xaa9AEb95B8892E495143990C2F8dD28D5eC94727 │  │
    ································|·············|············································|·············································
    |  Converter                    ·      1.595  · 0x96c9F1b2b1DCd4C8a3a1DbD0925a7B8Ed06e9D55 │  │
    ································|·············|············································|·············································
    |  LevelManager                 ·      5.950  · 0x6072fd316982b71541078C60e066AdF886f5EAEA │  │
    ································|·············|············································|·············································
    |  LimitManager                 ·      6.968  · 0x7A967Ce849F8Ed8528EB1864D703CB6d77c5CD42 │  │
    ································|·············|············································|·············································
    |  MarketManager                ·     10.170  · 0x586537611Bed944E6D639302706b84576b3c9ae8 │  │
    ································|·············|············································|·············································
    |  OkseCard                     ·     24.240  · 0xC4D70D0C160cd2483E8101b71266A6881852C31b │  │
    ································|·············|············································|·············································
    |  OkseCardPriceOracle          ·      6.017  · 0x5E79A2474281AE517689790eE8457741726c793e │  │
    ································|·············|············································|·············································
    |  SpookySwapper                ·      4.235  · 0xe2acB82AADDe1f6e3a3E5eF3E5d8Fba381dc2213 │  │
    ································|·············|············································|·············································
    |  OkseToken                    ·      2.505  ·                                            │  │
    ································|·············|············································|·············································
    |  Manager                      ·      0.128  ·                                            │  │
    ································|·············|············································|·············································
    |  Math                         ·      0.045  ·                                            │  │
    ································|·············|············································|·············································
    |  MultiSigOwner                ·      2.641  ·                                            │  │
    ································|·············|············································|·············································
    |  OwnerConstants               ·      7.024  ·                                            │  │
    ································|·············|············································|·············································
    |  PancakeSwapper               ·      3.651  ·                                            │  │
    ································|·············|············································|·············································
    |  ProfitShare                  ·      3.011  ·                                            │  │
    ································|·············|············································|·············································
    |  ProxyAdmin                   ·      2.114  ·                                            │  │
    ································|·············|············································|·············································
    |  QuickSwapper                 ·      3.096  ·                                            │  │
    ································|·············|············································|·············································
    |  Roles                        ·      0.045  ·                                            │  │
    ································|·············|············································|·············································
    |  SafeMath                     ·      0.045  ·                                            │  │
    ································|·············|············································|·············································
    |  SafeMathUniswap              ·      0.045  ·                                            │  │
    ································|·············|············································|·············································
    |  SushiSwapper                 ·      3.214  ·                                            │  │
    ································|·············|············································|·············································
    |  TransferHelper               ·      0.045  ·                                            │  │
    ································|·············|············································|·············································
    |  TransparentUpgradeableProxy  ·      2.044  ·                                            │  │
    ································|·············|············································|·············································
    |  UniswapV2Library             ·      0.045  ·                                            │  │
    ································|·············|············································|·············································
    |  UpgradeableProxy             ·      0.682  ·                                            │  │
    ································|·············|············································|·············································
    |  UQ112x112                    ·      0.045  ·                                            │  │
    ·-------------------------------|-------------|---------------·····························|·············································
