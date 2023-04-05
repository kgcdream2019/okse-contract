// SPDX-License-Identifier: LICENSED
pragma solidity ^0.7.0;

interface IVault {
    function calculateRedeemOutput(
        uint256 _amount
    ) external view returns (uint256, uint256, uint256);

    function primaryStableAddress() external view returns (address);

    function price2() external view returns (uint256);

    function price() external view returns (uint256);

    function redeem(uint256 _amount, uint256 _minimumUnitAmount) external;
}
