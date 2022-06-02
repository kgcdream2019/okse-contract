// SPDX-License-Identifier: LICENSED
pragma solidity ^0.7.0;

interface IMarketManager {
    function WETH() external view returns (address);

    function USDC() external view returns (address);

    function OKSE() external view returns (address);

    function defaultMarket() external view returns (address);

    function oksePaymentEnable() external view returns (bool);

    function allMarkets() external view returns (address[] memory);

    function marketEnable(address market) external view returns (bool);

    function userMainMarket(address userAddr) external view returns (address);

    function getUserMainMarket(address userAddr)
        external
        view
        returns (address);

    function setUserMainMakret(
        address userAddr,
        address market
    ) external;
}
