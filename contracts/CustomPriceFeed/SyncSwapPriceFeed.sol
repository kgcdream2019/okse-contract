//SPDX-License-Identifier: LICENSED

pragma solidity ^0.7.0;
import "../interfaces/AggregatorV3Interface.sol";
import "../interfaces/ERC20Interface.sol";
import "../libraries/SafeMath.sol";
import "../interfaces/ISwapper.sol";

contract SyncSwapPriceFeed is AggregatorV3Interface {
    using SafeMath for uint256;
    address public immutable USDC;
    address public immutable token;
    address public swapper;
    uint256 public testAmountsIn;
    address public owner;
    uint8 _decimals;
    string _description;
    uint256 _version;
    // events
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    modifier onlyOwner() {
        require(msg.sender == owner, "oo");
        _;
    }

    function transaferOwnership(address newOwner) public onlyOwner {
        address oldOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    constructor(address _token, address _USDC, address _swapper) {
        token = _token;
        USDC = _USDC;
        swapper = _swapper;
        testAmountsIn = 1 ether;
        owner = msg.sender;
        _decimals = 8;
        _description = "SyncSwap price feed";
        _version = 1;
    }

    function setDecimals(uint8 _value) public onlyOwner {
        _decimals = _value;
    }

    function setDescription(string memory _value) public onlyOwner {
        _description = _value;
    }

    function setVersion(uint256 _value) public onlyOwner {
        _version = _value;
    }

    function decimals() external view override returns (uint8) {
        return _decimals;
    }

    function description() external view override returns (string memory) {
        return _description;
    }

    function version() external view override returns (uint256) {
        return _version;
    }

    function setTestAmount(uint256 _value) public onlyOwner {
        testAmountsIn = _value;
    }

    function setSwapper(address _swapper) public onlyOwner {
        swapper = _swapper;
    }

    // getRoundData and latestRoundData should both raise "No data present"
    // if they do not have data to report, instead of returning unset values
    // which could be misinterpreted as actual reported values.
    function getRoundData(
        uint80 _roundId
    )
        external
        view
        override
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        roundId = _roundId;
        answer = getPrice();
        startedAt = block.timestamp;
        updatedAt = block.timestamp;
        answeredInRound = uint80(block.number);
    }

    function latestRoundData()
        external
        view
        override
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        roundId = uint80(block.number);
        answer = getPrice();
        startedAt = block.timestamp;
        updatedAt = block.timestamp;
        answeredInRound = uint80(block.number);
    }

    function getPrice() public view returns (int256) {
        uint256 amountIn = testAmountsIn;
        address[] memory path = ISwapper(swapper).getOptimumPath(token, USDC);
        uint256[] memory amounts = ISwapper(swapper).getAmountsOut(
            amountIn,
            path
        );
        uint256 _dec = _decimals + ERC20Interface(token).decimals();
        uint256 usdcDecimal = ERC20Interface(USDC).decimals();
        int256 price;
        if (_dec >= usdcDecimal) {
            price = int256(
                (amounts[1].mul(uint256(10 ** uint256(_dec - usdcDecimal))))
                    .div(testAmountsIn)
            );
        } else {
            price = int256(
                amounts[1].div(uint256(10 ** uint256(usdcDecimal - _dec))).div(
                    testAmountsIn
                )
            );
        }
        return price;
    }
}
