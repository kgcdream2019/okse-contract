// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
/**
 * @title Swap - A StableSwap implementation in solidity.
 * @notice This contract is responsible for custody of closely pegged assets (eg. group of stablecoins)
 * and automatic market making system. Users become an LP (Liquidity Provider) by depositing their tokens
 * in desired ratios for an exchange of the pool token that represents their share of the pool.
 * Users can burn pool tokens and withdraw their share of token(s).
 *
 * Each time a swap between the pooled tokens happens, a set fee incurs which effectively gets
 * distributed to the LPs.
 *
 * In case of emergencies, admin can pause additional deposits, swaps, or single-asset withdraws - which
 * stops the ratio of the tokens in the pool from changing.
 * Users can always withdraw their tokens via multi-asset withdraws.
 *
 * @dev Most of the logic is stored as a library `SwapUtils` for the sake of reducing contract's
 * deployment size.
 */
interface IStableSwap {
    /*** VIEW FUNCTIONS ***/

    /**
     * @notice Return A, the amplification coefficient * n * (n - 1)
     * @dev See the StableSwap paper for details
     * @return A parameter
     */
    function getA() external view returns (uint256);

    /**
     * @notice Return A in its raw precision form
     * @dev See the StableSwap paper for details
     * @return A parameter in its raw precision form
     */
    function getAPrecise() external view returns (uint256);

    /**
     * @notice Return address of the pooled token at given index. Reverts if tokenIndex is out of range.
     * @param index the index of the token
     * @return address of the token at given index
     */
    function getToken(uint8 index) external view returns (address);

    function getTokensArray() external view returns (address[] memory);

    /**
     * @notice Return the index of the given token address. Reverts if no matching
     * token is found.
     * @param tokenAddress address of the token
     * @return the index of the given token address
     */
    function getTokenIndex(address tokenAddress) external view returns (uint8);

    /**
     * @notice Return current balance of the pooled token at given index
     * @param index the index of the token
     * @return current balance of the pooled token at given index with token's native precision
     */
    function getTokenBalance(uint8 index) external view returns (uint256);

    /**
     * @notice Get the virtual price, to help calculate profit
     * @return the virtual price, scaled to the POOL_PRECISION_DECIMALS
     */
    function getVirtualPrice() external view returns (uint256);

    /**
     * @notice Calculate amount of tokens you receive on swap
     * @param tokenIndexFrom the token the user wants to sell
     * @param tokenIndexTo the token the user wants to buy
     * @param dx the amount of tokens the user wants to sell. If the token charges
     * a fee on transfers, use the amount that gets transferred after the fee.
     * @return amount of tokens the user will receive
     */
    function calculateSwap(
        uint8 tokenIndexFrom,
        uint8 tokenIndexTo,
        uint256 dx
    ) external view returns (uint256);

    /**
     * @notice A simple method to calculate prices from deposits or
     * withdrawals, excluding fees but including slippage. This is
     * helpful as an input into the various "min" parameters on calls
     * to fight front-running
     *
     * @dev This shouldn't be used outside frontends for user estimates.
     *
     * @param amounts an array of token amounts to deposit or withdrawal,
     * corresponding to pooledTokens. The amount should be in each
     * pooled token's native precision. If a token charges a fee on transfers,
     * use the amount that gets transferred after the fee.
     * @param deposit whether this is a deposit or a withdrawal
     * @return token amount the user will receive
     */
    function calculateTokenAmount(
        uint256[] calldata amounts,
        bool deposit
    ) external view returns (uint256);

    /*** STATE MODIFYING FUNCTIONS ***/

    /**
     * @notice Swap two tokens using this pool
     * @param tokenIndexFrom the token the user wants to swap from
     * @param tokenIndexTo the token the user wants to swap to
     * @param dx the amount of tokens the user wants to swap from
     * @param minDy the min amount the user would like to receive, or revert.
     * @param deadline latest timestamp to accept this transaction
     */
    function swap(
        uint8 tokenIndexFrom,
        uint8 tokenIndexTo,
        uint256 dx,
        uint256 minDy,
        uint256 deadline
    ) external returns (uint256);
}
