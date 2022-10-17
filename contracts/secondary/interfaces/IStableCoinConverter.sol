// SPDX-License-Identifier: LICENSED
pragma solidity ^0.7.0;

interface IStableCoinConverter {
    function run(uint256 slippage) external;

    function checkExecuteCondition() external view returns (bool);

    function getTokenBalance() external view returns (uint256);

    function approve(address token, address target) external;
}
