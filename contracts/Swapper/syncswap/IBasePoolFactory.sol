// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity >=0.5.0;


interface IBasePoolFactory {

    function getPool(address tokenA, address tokenB) external view returns (address pool);

    function getSwapFee(
        address pool,
        address sender,
        address tokenIn,
        address tokenOut,
        bytes calldata data
    ) external view returns (uint24 swapFee);
}