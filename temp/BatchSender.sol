//SPDX-License-Identifier: LICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.7.0;
pragma abicoder v2;
import "@openzeppelin/contracts/access/Ownable.sol";
import "../libraries/TransferHelper.sol";
import "../interfaces/ERC20Interface.sol";

contract BatchSender is Ownable {
    constructor() {}

    receive() external payable {}

    function sendBatchETH(address[] calldata receivers, uint256[] calldata amounts)
        external
        payable
    {
        uint256 totalAmount = 0;
        require(receivers.length == amounts.length, "invalid input param");
        for (uint256 i = 0; i < receivers.length; i++) {
            address to = receivers[i];
            uint256 value = amounts[i];
            TransferHelper.safeTransferETH(to, value);
            totalAmount = totalAmount + value;
        }
        require(totalAmount <= msg.value, "lacks of ETH");
        if (msg.value > totalAmount) {
            TransferHelper.safeTransferETH(msg.sender, msg.value - totalAmount);
        }
    }

    function sendBatch(
        address token,
        uint256 amount,
        address[] calldata receivers,
        uint256[] calldata amounts
    ) external {
        TransferHelper.safeTransferFrom(
            token,
            tx.origin,
            address(this),
            amount
        );
        require(receivers.length == amounts.length, "invalid input param");
        uint256 totalAmount = 0;
        for (uint256 i = 0; i < receivers.length; i++) {
            address to = receivers[i];
            uint256 value = amounts[i];
            TransferHelper.safeTransfer(token, to, value);
            totalAmount = totalAmount + value;
        }
        require(totalAmount <= amount, "lacks of token");
        if (amount > totalAmount) {
            TransferHelper.safeTransferETH(tx.origin, amount - totalAmount);
        }
    }

    function withdrawTokens(address token, address to) external onlyOwner {
        uint256 value = getBalance(token);
        if (token == address(0)) {
            TransferHelper.safeTransferETH(to, value);
        } else {
            TransferHelper.safeTransfer(token, to, value);
        }
    }

    function getBalance(address token) public view returns (uint256) {
        uint256 balance;
        if (token == address(0)) {
            address payable self = payable(address(this));
            balance = self.balance;
        } else {
            balance = ERC20Interface(token).balanceOf(address(this));
        }
        return balance;
    }
}
