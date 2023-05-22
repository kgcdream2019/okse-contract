// Sources flattened with hardhat v2.9.6 https://hardhat.org

// File contracts/interfaces/ERC20Interface.sol

//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

interface ERC20Interface {
  /**
   * @dev Returns the amount of tokens in existence.
   */
  function totalSupply() external view returns (uint256);

  /**
   * @dev Returns the token decimals.
   */
  function decimals() external view returns (uint8);

  /**
   * @dev Returns the token symbol.
   */
  function symbol() external view returns (string memory);

  /**
  * @dev Returns the token name.
  */
  function name() external view returns (string memory);

  /**
   * @dev Returns the bep token owner.
   */
  function getOwner() external view returns (address);

  /**
   * @dev Returns the amount of tokens owned by `account`.
   */
  function balanceOf(address account) external view returns (uint256);

  /**
   * @dev Moves `amount` tokens from the caller's account to `recipient`.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transfer(address recipient, uint256 amount) external returns (bool);

  /**
   * @dev Returns the remaining number of tokens that `spender` will be
   * allowed to spend on behalf of `owner` through {transferFrom}. This is
   * zero by default.
   *
   * This value changes when {approve} or {transferFrom} are called.
   */
  function allowance(address _owner, address spender) external view returns (uint256);

  /**
   * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * IMPORTANT: Beware that changing an allowance with this method brings the risk
   * that someone may use both the old and the new allowance by unfortunate
   * transaction ordering. One possible solution to mitigate this race
   * condition is to first reduce the spender's allowance to 0 and set the
   * desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   *
   * Emits an {Approval} event.
   */
  function approve(address spender, uint256 amount) external returns (bool);

  /**
   * @dev Moves `amount` tokens from `sender` to `recipient` using the
   * allowance mechanism. `amount` is then deducted from the caller's
   * allowance.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

  /**
   * @dev Emitted when `value` tokens are moved from one account (`from`) to
   * another (`to`).
   *
   * Note that `value` may be zero.
   */
  event Transfer(address indexed from, address indexed to, uint256 value);

  /**
   * @dev Emitted when the allowance of a `spender` for an `owner` is set by
   * a call to {approve}. `value` is the new allowance.
   */
  event Approval(address indexed owner, address indexed spender, uint256 value);
}


// File @openzeppelin/contracts/utils/Context.sol@v3.4.2

// -License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


// File @openzeppelin/contracts/access/Ownable.sol@v3.4.2

// -License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.2

// -License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


// File contracts/libraries/TransferHelper.sol

// -License-Identifier: GPL-2.0-or-later
pragma solidity >=0.6.0;

library TransferHelper {
    /// @notice Transfers tokens from the targeted address to the given destination
    /// @notice Errors with 'STF' if transfer fails
    /// @param token The contract address of the token to be transferred
    /// @param from The originating address from which the tokens will be transferred
    /// @param to The destination address of the transfer
    /// @param value The amount to be transferred
    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 value
    ) internal {
        (bool success, bytes memory data) =
            token.call(abi.encodeWithSelector(IERC20.transferFrom.selector, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'STF');
    }

    /// @notice Transfers tokens from msg.sender to a recipient
    /// @dev Errors with ST if transfer fails
    /// @param token The contract address of the token which will be transferred
    /// @param to The recipient of the transfer
    /// @param value The value of the transfer
    function safeTransfer(
        address token,
        address to,
        uint256 value
    ) internal {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(IERC20.transfer.selector, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'ST');
    }

    /// @notice Approves the stipulated contract to spend the given allowance in the given token
    /// @dev Errors with 'SA' if transfer fails
    /// @param token The contract address of the token to be approved
    /// @param to The target of the approval
    /// @param value The amount of the given token the target will be allowed to spend
    function safeApprove(
        address token,
        address to,
        uint256 value
    ) internal {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(IERC20.approve.selector, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'SA');
    }

    /// @notice Transfers ETH to the recipient address
    /// @dev Fails with `STE`
    /// @param to The destination of the transfer
    /// @param value The value to be transferred
    function safeTransferETH(address to, uint256 value) internal {
        (bool success, ) = to.call{value: value}(new bytes(0));
        require(success, 'STE');
    }
}


// File contracts/Swapper/quickswap/interfaces/IUniswapV2Pair.sol

pragma solidity >=0.5.0;

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}


// File contracts/Swapper/quickswap/libraries/SafeMath.sol

pragma solidity >=0.6.12;

// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)

library SafeMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, 'ds-math-add-overflow');
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, 'ds-math-sub-underflow');
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
    }

    function div(uint a, uint b) internal pure returns (uint256) {
        require(b > 0, "division by zero");
        return a / b;
    }
}


// File contracts/Swapper/quickswap/libraries/UniswapV2Library.sol

pragma solidity >=0.5.0;

library UniswapV2Library {
    using SafeMath for uint;

    function checkAndConvertETHToWETH(address token) internal pure returns(address) {
        
        if(token == address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)) {
            return address(0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270);
        }
        return token;
    }

    // returns sorted token addresses, used to handle return values from pairs sorted in this order
    function sortTokens(address tokenA, address tokenB) internal pure returns (address, address) {
        tokenA = checkAndConvertETHToWETH(tokenA);
        tokenB = checkAndConvertETHToWETH(tokenB);
        return(tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA));
    }

    // calculates the CREATE2 address for a pair without making any external calls
    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address) {
        (address token0, address token1) = sortTokens(tokenA, tokenB);
        return(address(uint(keccak256(abi.encodePacked(
                hex'ff',
                factory,
                keccak256(abi.encodePacked(token0, token1)),
                hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
            )))));
    }

    // fetches and sorts the reserves for a pair
    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
        (address token0,) = sortTokens(tokenA, tokenB);
        (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    function getReservesByPair(address pair, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
        (address token0,) = sortTokens(tokenA, tokenB);
        (uint reserve0, uint reserve1,) = IUniswapV2Pair(pair).getReserves();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
        require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
        require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        amountB = amountA.mul(reserveB) / reserveA;
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
        uint amountInWithFee = amountIn.mul(997);
        uint numerator = amountInWithFee.mul(reserveOut);
        uint denominator = reserveIn.mul(1000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }

    function getAmountOutByPair(uint256 amountIn, address pair, address tokenA, address tokenB) internal view returns(uint256 amountOut) {
        (uint reserveIn, uint reserveOut) = getReservesByPair(pair, tokenA, tokenB);
        return (getAmountOut(amountIn, reserveIn, reserveOut));
    }

    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
        require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        uint numerator = reserveIn.mul(amountOut).mul(1000);
        uint denominator = reserveOut.sub(amountOut).mul(997);
        amountIn = (numerator / denominator).add(1);
    }

    // performs chained getAmountOut calculations on any number of pairs
    function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[0] = amountIn;
        for (uint i; i < path.length - 1; i++) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
        }
    }

    // performs chained getAmountIn calculations on any number of pairs
    function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint i = path.length - 1; i > 0; i--) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
        }
    }
}


// File contracts/Swapper/satin/interfaces/IBasePair.sol

//-License-Identifier: LICENSED
pragma solidity ^0.7.0;
interface IBaseV1Pair {
    function transferFrom(address src, address dst, uint amount) external returns (bool);
    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function burn(address to) external returns (uint amount0, uint amount1);
    function mint(address to) external returns (uint liquidity);
    function getReserves() external view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast);
    function getAmountOut(uint, address) external view returns (uint);
    function prices(address tokenIn, uint amountIn, uint points) external view returns (uint[] memory);
}


// File contracts/Swapper/satin/interfaces/IBaseV1Router01.sol

//-License-Identifier: LICENSED
pragma solidity ^0.7.0;
pragma abicoder v2;
interface IBaseV1Router01 {
    struct route {
        address from;
        address to;
        bool stable;
    }

    function sortTokens(
        address tokenA,
        address tokenB
    ) external pure returns (address token0, address token1);

    // calculates the CREATE2 address for a pair without making any external calls
    function pairFor(
        address tokenA,
        address tokenB,
        bool stable
    ) external view returns (address pair);

    // fetches and sorts the reserves for a pair
    function getReserves(
        address tokenA,
        address tokenB,
        bool stable
    ) external view returns (uint reserveA, uint reserveB);

    // performs chained getAmountOut calculations on any number of pairs
    function getAmountOut(
        uint amountIn,
        address tokenIn,
        address tokenOut
    ) external view returns (uint amount, bool stable);

    // performs chained getAmountOut calculations on any number of pairs
    function getAmountsOut(
        uint amountIn,
        route[] memory routes
    ) external view returns (uint[] memory amounts);

    function isPair(address pair) external view returns (bool);

    function swapExactTokensForTokensSimple(
        uint amountIn,
        uint amountOutMin,
        address tokenFrom,
        address tokenTo,
        bool stable,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        route[] calldata routes,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapExactFTMForTokens(
        uint amountOutMin,
        route[] calldata routes,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);

    function swapExactTokensForFTM(
        uint amountIn,
        uint amountOutMin,
        route[] calldata routes,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function UNSAFE_swapExactTokensForTokens(
        uint[] memory amounts,
        route[] calldata routes,
        address to,
        uint deadline
    ) external returns (uint[] memory);
}


// File contracts/Swapper/satin/interfaces/IStableSwap.sol

// -License-Identifier: MIT
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


// File contracts/interfaces/PriceOracle.sol

//-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

abstract contract PriceOracle {
    /// @notice Indicator that this is a PriceOracle contract (for inspection)
    bool public constant isPriceOracle = true;

    /**
      * @notice Get the underlying price of a cToken asset
      * @param market The cToken to get the underlying price of
      * @return The underlying asset price mantissa (scaled by 1e18).
      *  Zero means the price is unavailable.
      */
    function getUnderlyingPrice(address market) external virtual view returns (uint);

}


// File contracts/interfaces/IVault.sol

// -License-Identifier: LICENSED
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


// File contracts/Swapper/PolygonSwapper.sol

//-License-Identifier: LICENSED
pragma solidity ^0.7.0;
pragma abicoder v2;
contract PolygonSwapper is Ownable {
    using SafeMath for uint256;
    address public vault = 0xd1bb7d35db39954d43e16f65F09DD0766A772cFF; // CASH vault
    address public stableswap = 0x3789e9AbCe84484FDb5C337c8E44B24eABBa331a; // 4 POOL for stable swap
    address public factory = 0x5757371414417b8C6CAad45bAeF941aBc7d3Ab32; // quickswap factory

    address public CASH = 0x80487b4f8f70e793A81a42367c225ee0B94315DF; // CASH
    address public WMATIC = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
    address public USDT = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F;
    address public OKSE = 0xFf1674D39dEf5d3840f4021FAD2c5D4F20520557;
    address public USDC = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
    address public DAI = 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063;

    address public router = 0x1Bc01517Bda7135B00d629B61DCe41F7AF070C53; // Satin router

    uint256 slippage = 30000;
    uint256 public constant SLIPPAGE_MAX = 1000000;
    address public priceOracle = 0xcbeDEe9C29E92d61adD691dE46bc6d4F4Bb070A7;
    mapping(address => address) public middleTokenList;

    event PriceOracleUpdated(address priceOracle);
    event SlippageUpdated(uint256 slippage);
    event MiddleTokenUpdated(address tokenAddr, address middleToken);

    constructor() {}

    function _swap(
        uint256[] memory amounts,
        address[] memory path,
        address _to
    ) external {
        if (path[0] == CASH) {
            swapCash(_to);
        } else if (path[0] == OKSE) {
            swapOkse(_to);
        } else {
            swapInQuickSwap(amounts, path, _to);
        }
    }

    function swapCashUsingVault(address _to) public {
        // redeem
        uint256 _amount = ERC20Interface(CASH).balanceOf(address(this));
        uint256 _minimumUnitAmount = 0;
        IVault(vault).redeem(_amount, _minimumUnitAmount);
        // convert USDC to USDT
        convertToUsdt(DAI, address(this));
        // convert DAI to USDT
        convertToUsdt(USDC, address(this));
        uint256 usdtBalance = ERC20Interface(USDT).balanceOf(address(this));
        TransferHelper.safeTransfer(USDT, _to, usdtBalance);
    }

    function swapCash(address _to) internal {
        // redeem
        uint256 _amount = ERC20Interface(CASH).balanceOf(address(this));

        TransferHelper.safeApprove(CASH, stableswap, _amount);
        uint8 tokenIndexFrom = IStableSwap(stableswap).getTokenIndex(CASH);
        uint8 tokenIndexTo = IStableSwap(stableswap).getTokenIndex(USDT);
        uint256 minDy = IStableSwap(stableswap).calculateSwap(
            tokenIndexFrom,
            tokenIndexTo,
            _amount
        );
        minDy = minDy.sub(minDy.mul(slippage).div(SLIPPAGE_MAX));
        uint256 deadline = block.timestamp;
        IStableSwap(stableswap).swap(
            tokenIndexFrom,
            tokenIndexTo,
            _amount,
            minDy,
            deadline
        );
        uint256 usdtBalance = ERC20Interface(USDT).balanceOf(address(this));
        TransferHelper.safeTransfer(USDT, _to, usdtBalance);
    }

    function swapOkse(address _to) internal {
        uint256 amountIn = ERC20Interface(OKSE).balanceOf(address(this));
        TransferHelper.safeApprove(OKSE, address(router), amountIn);
        IBaseV1Router01(router).swapExactTokensForTokensSimple(
            amountIn,
            0,
            OKSE,
            CASH,
            false,
            address(this),
            block.timestamp
        );
        swapCash(_to);
    }

    function swapInQuickSwap(
        uint256[] memory amounts,
        address[] memory path,
        address _to
    ) internal {
        for (uint256 i; i < path.length - 1; i++) {
            (address input, address output) = (path[i], path[i + 1]);
            (address token0, ) = UniswapV2Library.sortTokens(input, output);
            uint256 amountOut = amounts[i + 1];
            (uint256 amount0Out, uint256 amount1Out) = input == token0
                ? (uint256(0), amountOut)
                : (amountOut, uint256(0));
            address to = i < path.length - 2
                ? UniswapV2Library.pairFor(factory, output, path[i + 2])
                : _to;
            IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output))
                .swap(amount0Out, amount1Out, to, new bytes(0));
        }
    }

    function convertToUsdt(address token, address _to) internal {
        uint256 amountIn = ERC20Interface(token).balanceOf(address(this));
        if (amountIn == 0) return;
        address[] memory path = new address[](2);
        path[0] = token;
        path[1] = USDT;
        TransferHelper.safeTransfer(
            token,
            UniswapV2Library.pairFor(factory, token, USDT),
            amountIn
        );
        uint256[] memory amounts = UniswapV2Library.getAmountsOut(
            factory,
            amountIn,
            path
        );
        swapInQuickSwap(amounts, path, _to);
    }

    function getAmountsInForCash(
        uint256 amountOut,
        address[] memory path
    ) public view returns (uint256[] memory amounts) {
        amounts = new uint256[](2);
        uint256 cashPrice = IVault(vault).price();
        require(cashPrice > 0, "cash price error");
        uint256 amountIn = amountOut.mul(10 ** 30).div(cashPrice);
        uint8 tokenIndexFrom = IStableSwap(stableswap).getTokenIndex(CASH);
        uint8 tokenIndexTo = IStableSwap(stableswap).getTokenIndex(USDT);
        uint256 calcAmountOut = IStableSwap(stableswap).calculateSwap(
            tokenIndexFrom,
            tokenIndexTo,
            amountIn
        );
        require(calcAmountOut > 0, "div by zero");
        amounts[0] = amountIn.mul(amountOut).div(calcAmountOut);
        amounts[1] = amountOut;
    }

    function getAmountsIn(
        uint256 amountOut,
        address[] memory path
    ) external view returns (uint256[] memory amounts) {
        if (path[0] == CASH) {
            amounts = getAmountsInForCash(amountOut, path);
        } else if (path[0] == OKSE) {
            amounts = getAmountsInForCash(amountOut, path);
            address[] memory newPath = new address[](2);
            newPath[0] = OKSE;
            newPath[1] = CASH;
            amounts = getAmountsInFromSatin(amounts[0], newPath);
            amounts[1] = amountOut;
        } else {
            return UniswapV2Library.getAmountsIn(factory, amountOut, path);
        }
    }

    function getAmountsInFromSatin(
        uint256 amountOut,
        address[] memory path
    ) public view returns (uint256[] memory amounts) {
        require(path.length == 2 || path.length == 3, "invalid length");
        uint256 usdAmount = getUsdAmount(
            path[path.length - 1],
            amountOut,
            priceOracle
        );
        uint256 amountIn = getAssetAmount(path[0], usdAmount, priceOracle);
        amounts = new uint256[](path.length);
        amountIn = amountIn.add(amountIn.mul(slippage).div(SLIPPAGE_MAX));
        IBaseV1Router01.route[] memory routes = new IBaseV1Router01.route[](
            path.length - 1
        );
        for (uint256 i = 0; i < path.length - 1; i++) {
            routes[i].from = path[i];
            routes[i].to = path[i + 1];
            routes[i].stable = false;
        }
        amounts = IBaseV1Router01(router).getAmountsOut(amountIn, routes);
        amounts[0] = amountIn.mul(amountOut).div(amounts[path.length - 1]);
        amounts[path.length - 1] = amountOut;
    }

    function getUsdAmount(
        address market,
        uint256 assetAmount,
        address _priceOracle
    ) public view returns (uint256 usdAmount) {
        uint256 usdPrice = PriceOracle(_priceOracle).getUnderlyingPrice(market);
        require(usdPrice > 0, "upe");
        usdAmount = (assetAmount.mul(usdPrice)).div(10 ** 8);
    }

    // verified not
    function getAssetAmount(
        address market,
        uint256 usdAmount,
        address _priceOracle
    ) public view returns (uint256 assetAmount) {
        uint256 usdPrice = PriceOracle(_priceOracle).getUnderlyingPrice(market);
        require(usdPrice > 0, "usd price error");
        assetAmount = (usdAmount.mul(10 ** 8)).div(usdPrice);
    }

    function getAmountOutForCash(
        uint256 amountIn
    ) public view returns (uint256[] memory amounts) {
        amounts = new uint256[](2);
        uint8 tokenIndexFrom = IStableSwap(stableswap).getTokenIndex(CASH);
        uint8 tokenIndexTo = IStableSwap(stableswap).getTokenIndex(USDT);
        uint256 amountOut = IStableSwap(stableswap).calculateSwap(
            tokenIndexFrom,
            tokenIndexTo,
            amountIn
        );

        amounts[0] = amountIn;
        amounts[1] = amountOut;
    }

    function getAmountsOut(
        uint256 amountIn,
        address[] memory path
    ) external view returns (uint256[] memory amounts) {
        if (path[0] == CASH) {
            return getAmountOutForCash(amountIn);
        } else if (path[0] == OKSE && path[1] == USDT) {
            address[] memory newPath = new address[](2);
            newPath[0] = OKSE;
            newPath[1] = CASH;
            amounts = getAmountsOutFromSatin(amountIn, newPath);
            return getAmountOutForCash(amounts[1]);
        } else {
            return UniswapV2Library.getAmountsOut(factory, amountIn, path);
        }
    }

    function getAmountsOutFromSatin(
        uint256 amountIn,
        address[] memory path
    ) public view returns (uint256[] memory amounts) {
        IBaseV1Router01.route[] memory routes = new IBaseV1Router01.route[](
            path.length - 1
        );
        for (uint256 i = 0; i < path.length - 1; i++) {
            routes[i].from = path[i];
            routes[i].to = path[i + 1];
            routes[i].stable = false;
        }
        return IBaseV1Router01(router).getAmountsOut(amountIn, routes);
    }

    function GetReceiverAddress(
        address[] memory path
    ) external view returns (address) {
        if (path[0] == CASH || path[0] == OKSE) {
            return address(this);
        }
        return UniswapV2Library.pairFor(factory, path[0], path[1]);
    }

    function getOptimumPath(
        address token0,
        address token1
    ) external view returns (address[] memory path) {
        if (middleTokenList[token0] != address(0) && token1 == USDT) {
            path = new address[](3);
            path[0] = token0;
            path[1] = middleTokenList[token0];
            path[2] = USDT;
        } else {
            path = new address[](2);
            path[0] = token0;
            path[1] = token1;
        }
    }

    function setPriceOracle(address _priceoracle) external onlyOwner {
        priceOracle = _priceoracle;
        emit PriceOracleUpdated(priceOracle);
    }

    function setSlippage(uint256 _slippage) external onlyOwner {
        require(_slippage <= SLIPPAGE_MAX, "overflow slippage");
        slippage = _slippage;
        emit SlippageUpdated(slippage);
    }

    function _setMiddleToken(address tokenAddr, address middleToken) internal {
        middleTokenList[tokenAddr] = middleToken;
        emit MiddleTokenUpdated(tokenAddr, middleToken);
    }

    function setMiddleToken(
        address tokenAddr,
        address middleToken
    ) external onlyOwner {
        _setMiddleToken(tokenAddr, middleToken);
    }
}
