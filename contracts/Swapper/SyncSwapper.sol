//SPDX-License-Identifier: LICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.7.0;
pragma abicoder v2;
import "./syncswap/IBasePool.sol";
import "./syncswap/IBasePoolFactory.sol";
import "./syncswap/IVault.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../libraries/TransferHelper.sol";

// https://syncswap.gitbook.io/syncswap/smart-contracts/smart-contracts
// Classic Pool Factory     0xf2DAd89f2788a8CD54625C60b55cD3d2D0ACa7Cb
// Stable Pool Factory      0x5b9f21d407F35b10CbfDDca17D5D84b129356ea3
// Router                   0x2da10A1e27bF85cEdD8FFb1AbBe97e53391C0295
// Pool Master              0xbB05918E9B4bA9Fe2c8384d223f0844867909Ffb
// Vault                    0x621425a1Ef6abE91058E9712575dcc4258F8d091
contract SyncSwapper is Ownable {
    // factory address for AMM dex, normally we use spookyswap on fantom chain.
    address public classicFactory;
    address public stableFactory;
    address public vault;
    /// @dev Pools by its two pool tokens.
    // fasle => classic pool
    // true  => stable pool
    mapping(address => mapping(address => bool)) public poolTypes;
    mapping(address => address) public tokenList;
    event TokenSwapPathUpdated(address tokenAddr, address middleToken);

    constructor(
        address _classicFactory,
        address _stableFactory,
        address _vault
    ) {
        classicFactory = _classicFactory;
        stableFactory = _stableFactory;
        vault = _vault;
    }

    // **** SWAP ****
    // verified
    // requires the initial amount to have already been sent to the first pair
    function _swap(
        uint256[] memory amounts,
        address[] memory path,
        address _to
    ) public {
        IVault(vault).deposit(path[0], getPool(path[0], path[1]));
        for (uint256 i; i < path.length - 1; i++) {
            (address input, address output) = (path[i], path[i + 1]);
            address to = i < path.length - 2
                ? getPool(output, path[i + 2])
                : address(this);
            bytes memory data = abi.encode(input, to, uint8(0));
            IBasePool(getPool(input, output)).swap(
                data,
                msg.sender,
                address(0),
                new bytes(0)
            );
        }
        uint256 amount = IVault(vault).balanceOf(
            path[path.length - 1],
            address(this)
        );
        IVault(vault).withdraw(path[path.length - 1], _to, amount);
    }

    function getAmountsIn(
        uint256 amountOut,
        address[] memory path
    ) external view returns (uint256[] memory amounts) {
        require(path.length >= 2, "INVALID_PATH");
        amounts = new uint[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint i = path.length - 1; i > 0; i--) {
            address pool = getPool(path[i - 1], path[i]);
            amounts[i - 1] = IBasePool(pool).getAmountIn(
                path[i],
                amounts[i],
                address(this)
            );
        }
    }

    function getAmountsOut(
        uint256 amountIn,
        address[] memory path
    ) external view returns (uint256[] memory amounts) {
        require(path.length >= 2, "INVALID_PATH");
        amounts = new uint[](path.length);
        amounts[0] = amountIn;
        for (uint i; i < path.length - 1; i++) {
            address pool = getPool(path[i], path[i + 1]);
            amounts[i + 1] = IBasePool(pool).getAmountOut(
                path[i],
                amounts[i],
                address(this)
            );
        }
    }

    function getPool(
        address tokenA,
        address tokenB
    ) public view returns (address) {
        bool poolType = poolTypes[tokenA][tokenB];
        address factory;
        if (poolType) {
            factory = stableFactory;
        } else {
            factory = classicFactory;
        }
        return IBasePoolFactory(factory).getPool(tokenA, tokenB);
    }

    function GetReceiverAddress(
        address[] memory path
    ) external view returns (address) {
        return vault;
    }

    function getOptimumPath(
        address token0,
        address token1
    ) external view returns (address[] memory path) {
        if (tokenList[token0] != address(0)) {
            path = new address[](3);
            path[0] = token0;
            path[1] = tokenList[token0];
            path[2] = token1;
        } else {
            path = new address[](2);
            path[0] = token0;
            path[1] = token1;
        }
    }

    function _setMiddleToken(address tokenAddr, address middleToken) internal {
        tokenList[tokenAddr] = middleToken;
        emit TokenSwapPathUpdated(tokenAddr, middleToken);
    }

    function setMiddleToken(
        address tokenAddr,
        address middleToken
    ) external onlyOwner {
        _setMiddleToken(tokenAddr, middleToken);
    }

    function setPoolType(
        address tokenA,
        address tokenB,
        bool poolType
    ) external onlyOwner {
        poolTypes[tokenA][tokenB] = poolType;
        poolTypes[tokenB][tokenA] = poolType;
    }
}
