Add new USDC token to avaxc network
- new usdc address (USDC.e)  0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664

1) Marketanager addMarket usdc
   Marketanager 0x30342EBb1fa044A9BBFd4256973B5f551e654103
   usdc         0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664
2) MarketManager setparam okse, usdc
   Marketanager 0x30342EBb1fa044A9BBFd4256973B5f551e654103
   OKSE         0xbc7b0223dd16cbc679c0d04ba3f4530d76dfba87
   USDC         0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664

3) deploy new TraderJoeSwapper
    TraderjoeSwapper    0x451Dc7f50f4c89e9E3356515994a8024Ac792A8e
4) update PriceOracle
   OkseCardPriceOracle  0x4141c9420DF74d2379c1D3CD983a8c306Aa1A6b4
   addPriceFeed 0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664
   chainlink Feed USDC/USD   0xF096872672F44d6EBA71458D74fe67F9a77a23B9

5) OkseCard   setContractAddress  update new swapper, price oracle
    OkseCard    0xe47C751c72EF1d2723e021F8153567Bd3e076a70
            address _priceOracle    0x4141c9420DF74d2379c1D3CD983a8c306Aa1A6b4
            address _swapper        0x451Dc7f50f4c89e9E3356515994a8024Ac792A8e
            address _limitManager   0x25994d5f8b7984AfDEb8c935B0b12CA8a6956D37
            address _levelManager   0x40F5a9Bfd79585FFe39E93Efed59b84D27d6d593
            address _marketManager  0x30342EBb1fa044A9BBFd4256973B5f551e654103
            address _cashbackManager 0x4fc6321F218C1eb8E959F97bD6F918AC738e7f7c