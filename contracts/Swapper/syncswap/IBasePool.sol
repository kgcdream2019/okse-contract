// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity >=0.5.0;
pragma abicoder v2;
import "./IPool.sol";

interface IBasePool is IPool {
    function token0() external view returns (address);
    function token1() external view returns (address);

    function reserve0() external view returns (uint);
    function reserve1() external view returns (uint);
    function invariantLast() external view returns (uint);

    function getReserves() external view returns (uint, uint);
    function getAmountOut(address tokenIn, uint amountIn, address sender) external view returns (uint amountOut);
    function getAmountIn(address tokenOut, uint amountOut, address sender) external view returns (uint amountIn);

}