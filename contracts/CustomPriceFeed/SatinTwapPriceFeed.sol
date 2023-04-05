//SPDX-License-Identifier: LICENSED

pragma solidity ^0.7.0;
pragma abicoder v2;
import "../interfaces/AggregatorV3Interface.sol";
import "../interfaces/ERC20Interface.sol";
import "../interfaces/IVault.sol";
import "../libraries/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../Swapper/satin/interfaces/IBaseV1Router01.sol";

contract SatinTwapPriceFeed is AggregatorV3Interface, Ownable {
    using SafeMath for uint256;
    address public router = 0x1Bc01517Bda7135B00d629B61DCe41F7AF070C53; // Satin router
    address public immutable TOKEN;
    address public CASH = 0x80487b4f8f70e793A81a42367c225ee0B94315DF; // CASH
    address public OKSE = 0xFf1674D39dEf5d3840f4021FAD2c5D4F20520557;
    address public vault = 0xd1bb7d35db39954d43e16f65F09DD0766A772cFF; // CASH vault
    bool public stable;
    uint256 public testAmountsIn;
    uint8 _decimals;
    string _description;
    uint256 _version;

    // events

    constructor(address _token) {
        TOKEN = _token;
        stable = false;
        _decimals = 8;
        _description = "twap price feed for satin";
        _version = 1;
        testAmountsIn = 100 ether;
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

    function setTestAmount(uint256 _value) public onlyOwner {
        testAmountsIn = _value;
    }

    function setStable(bool _stable) public onlyOwner {
        stable = _stable;
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
        if (TOKEN == OKSE) {
            return getPriceOkse();
        } else if (TOKEN == CASH) {
            return getPriceCash();
        }
    }

    function getPriceOkse() public view returns (int256) {
        address poolAddress = IBaseV1Router01(router).pairFor(
            OKSE,
            CASH,
            stable
        );
        IBaseV1Router01.route[] memory routes = new IBaseV1Router01.route[](1);
        routes[0].from = OKSE;
        routes[0].to = CASH;
        routes[0].stable = false;
        uint256[] memory amounts = IBaseV1Router01(router).getAmountsOut(
            testAmountsIn,
            routes
        );
        uint256 cashPrice = IVault(vault).price();
        uint256 quoteAmount = amounts[1].mul(cashPrice).div(10 ** 30);

        uint256 _dec = _decimals + ERC20Interface(OKSE).decimals();
        uint256 usdcDecimal = 6;
        int256 price;
        if (_dec >= usdcDecimal) {
            price = int256(
                (quoteAmount.mul(uint256(10 ** uint256(_dec - usdcDecimal))))
                    .div(testAmountsIn)
            );
        } else {
            price = int256(
                quoteAmount.div(uint256(10 ** uint256(usdcDecimal - _dec))).div(
                    testAmountsIn
                )
            );
        }
        return price;
    }

    function getPriceCash() public view returns (int256) {
        uint256 quoteAmount = IVault(vault).price();

        uint256 usdcDecimal = 18;
        int256 price;
        if (_decimals >= usdcDecimal) {
            price = int256(
                (
                    quoteAmount.mul(
                        uint256(10 ** uint256(_decimals - usdcDecimal))
                    )
                )
            );
        } else {
            price = int256(
                quoteAmount.div(uint256(10 ** uint256(usdcDecimal - _decimals)))
            );
        }
        return price;
    }
}
