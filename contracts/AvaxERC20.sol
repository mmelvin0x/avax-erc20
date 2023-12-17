// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC20Base.sol";

contract AvaxERC20 is ERC20Base {
    uint256 private constant MAX_BPS = 10000;
    uint256 private immutable MAX_WALLET_CAP_BASIS_POINTS;

    constructor(address _defaultAdmin, string memory _name, string memory _symbol, uint256 _walletCapBasisPoints)
        ERC20Base(_defaultAdmin, _name, _symbol)
    {
        MAX_WALLET_CAP_BASIS_POINTS = _walletCapBasisPoints;
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        super._beforeTokenTransfer(from, to, amount);
        uint256 supply = totalSupply();
        uint256 currentBalance = balanceOf(to);
        uint256 maxWalletCap = (supply * MAX_WALLET_CAP_BASIS_POINTS) / 10000;

        require(currentBalance + amount <= maxWalletCap, "Transfer exceeds wallet cap");
    }
}
