//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;
import "../libraries/SafeMath.sol";
import "../interfaces/ERC20Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interface/IWombatRouter.sol";
import "./interface/ICelerBridge.sol";
import "../libraries/TransferHelper.sol";

contract StableCoinConverter is Ownable {
    using SafeMath for uint256;
    address public token;
    address public usdc;
    address public bridge;
    address public exchanger;
    address public usdcPool;
    uint256 public minAmount;
    uint256 public minDuration;
    uint256 public maxSlippage;
    uint256 public constant UINT_MAX =
        0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    address public receiver;
    uint256 lastExecuteTime;
    event WithdrawTokens(address token, address to, uint256 amount);
    event Executed(
        uint256 tokenBalance,
        uint256 lastExecuteTime,
        address bridge
    );

    constructor() {
        minAmount = 1 ether;
        minDuration = 1;
        maxSlippage = 0xe0590;
        receiver = 0x6318774fE107CA626eA90C88448A391b4E2A7014;
        exchanger = 0x19609B03C976CCA288fbDae5c21d4290e9a4aDD7;
        token = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
        usdc = 0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d;
        bridge = 0xdd90E5E87A2081Dcf0391920868eBc2FFB81a1aF;
        usdcPool = 0x312Bc7eAAF93f1C60Dc5AfC115FcCDE161055fb0;
    }

    function run() external {
        // check balance
        uint256 tokenBalance = ERC20Interface(token).balanceOf(address(this));
        require(tokenBalance >= minAmount, "balance is small");
        // check time
        require(
            lastExecuteTime + minDuration < block.timestamp,
            "time invalid"
        );

        // execute
        if (exchanger != address(0)) {
            swap(tokenBalance);
        }
        tokenBalance = ERC20Interface(usdc).balanceOf(address(this));
        send(tokenBalance);
        lastExecuteTime = block.timestamp;
        emit Executed(tokenBalance, lastExecuteTime, bridge);
    }

    function checkExecuteCondition() public view returns (bool) {
        uint256 tokenBalance = ERC20Interface(token).balanceOf(address(this));
        if (tokenBalance < minAmount) return false;
        if (lastExecuteTime + minDuration > block.timestamp) return false;
        return true;
    }

    function approve(address token, address target) external {
        ERC20Interface(token).approve(target, UINT_MAX);
    }

    function swap(uint256 amount) internal {
        address[] memory tokenPath = new address[](2);
        tokenPath[0] = token;
        tokenPath[1] = usdc;

        address[] memory poolPath = new address[](1);
        poolPath[0] = usdcPool;

        uint256 fromAmount = amount;
        uint256 minimumToAmount = (amount * 999) / 1000;
        address to = address(this);
        uint256 deadline = block.timestamp + 15 minutes;
        IWombatRouter(exchanger).swapExactTokensForTokens(
            tokenPath,
            poolPath,
            fromAmount,
            minimumToAmount,
            to,
            deadline
        );
    }

    function send(uint256 amount) internal {
        address _receiver = receiver;
        address _token = usdc;
        uint256 _amount = amount;
        uint64 _dstChainId = uint64(0x1);
        uint64 _nonce = uint64(block.timestamp);
        uint32 _maxSlippage = uint32(maxSlippage); // slippage * 1M, eg. 0.5% -> 5000
        ICelerBridge(bridge).send(
            _receiver,
            _token,
            _amount,
            _dstChainId,
            _nonce,
            _maxSlippage
        );
    }

    function withdrawTokens(address _token, address to) public onlyOwner {
        uint256 amount;
        if (_token == address(0)) {
            amount = address(this).balance;
            TransferHelper.safeTransferETH(to, amount);
        } else {
            amount = ERC20Interface(_token).balanceOf(address(this));
            TransferHelper.safeTransfer(_token, to, amount);
        }
        emit WithdrawTokens(_token, to, amount);
    }

    function setAddressParam(
        address _token,
        address _usdc,
        address _exchanger,
        address _bridge,
        address _receiver
    ) public onlyOwner {
        token = _token;
        usdc = _usdc;
        exchanger = _exchanger;
        bridge = _bridge;
        receiver = _receiver;
    }

    function setUintParam(
        uint256 _minAmount,
        uint256 _minDuration,
        uint256 _maxSlippage
    ) public onlyOwner {
        minAmount = _minAmount;
        minDuration = _minDuration;
        maxSlippage = _maxSlippage;
    }
}
