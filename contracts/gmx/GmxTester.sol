pragma solidity ^0.7.0;
pragma abicoder v2;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IRouter.sol";
import "./IPositionRouter.sol";
import "../libraries/TransferHelper.sol";
import "../interfaces/ERC20Interface.sol";

contract GmxTester is Ownable {
    address public constant router = 0x5F719c2F1095F7B9fc68a68e35B51194f4b6abe8;
    address public constant positionRouter =
        0x195256074192170d1530527abC9943759c7167d8;
    address public constant weth = 0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7;
    uint256 public constant amount = 1000000000000000000;

    function createIncreasePositionETH() external payable {}

    function approvePlugIn() public onlyOwner {
        IRouter(router).approvePlugin(positionRouter);
    }

    function createLongETH() public onlyOwner {
        address[] memory _path = new address[](1);
        _path[0] = weth;
        IPositionRouter(positionRouter).createIncreasePositionETH{
            value: 1.02 ether
        }(
            _path,
            weth, //_indexToken,
            0, //_minOut,
            0xDBBEBE76ECA1B12E19D0000000, //_sizeDelta,
            true, //_isLong,
            0xDBBEBE76ECA1B12E19D0000000, //_acceptablePrice,
            0x470de4df820000, //_executionFee,
            0 //_referralCode
        );
    }

    function withdraw(address token) public onlyOwner {
        uint256 amount;
        if (token == address(0)) {
            amount = address(this).balance;
            TransferHelper.safeTransferETH(msg.sender, amount);
        } else {
            amount = ERC20Interface(token).balanceOf(address(this));
            TransferHelper.safeTransfer(token, msg.sender, amount);
        }
    }

    // verified
    receive() external payable {
        // require(msg.sender == WETH, 'Not WETH9');
    }
}
