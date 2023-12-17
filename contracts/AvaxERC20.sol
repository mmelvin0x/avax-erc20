// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC20Base.sol";

contract AvaxERC20 is ERC20Base {
    uint256 private constant MAX_BPS = 10000;
    uint256 private immutable MAX_WALLET_CAP_BASIS_POINTS;
    uint256 private immutable MAX_SUPPLY;
    mapping(address => bool) private _whitelist;

    constructor(
        address _defaultAdmin,
        string memory _name,
        string memory _symbol,
        uint256 supply,
        uint256 _walletCapBasisPoints,
        address[] memory whitelist
    ) ERC20Base(_defaultAdmin, _name, _symbol) {
        // Set the max wallet cap in basis points
        MAX_WALLET_CAP_BASIS_POINTS = _walletCapBasisPoints;
        // Add the deployer to the whitelist
        _whitelist[msg.sender] = true;
        // Set the max supply
        MAX_SUPPLY = supply;

        // Add other wallets to the whitelist
        uint256 len = whitelist.length;
        // Require 5 or less on whitelist due to gas limits
        require(len <= 5, "Whitelist too large");
        for (uint256 i = 0; i < len;) {
            _whitelist[whitelist[i]] = true;

            unchecked {
                ++i;
            }
        }

        _mint(msg.sender, supply);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        super._beforeTokenTransfer(from, to, amount);
        uint256 supply = totalSupply();
        uint256 currentBalance = balanceOf(to);
        uint256 maxWalletCap = (supply * MAX_WALLET_CAP_BASIS_POINTS) / 10000;

        require(currentBalance + amount <= maxWalletCap, "Transfer exceeds wallet cap");
    }

    function mintTo(address to, uint256 amount) public override {
        require(_whitelist[msg.sender], "Not authorized to mint.");
        require(amount != 0, "Minting zero tokens.");
        require(totalSupply() + amount <= MAX_SUPPLY, "Minting exceeds max supply");

        _mint(to, amount);
    }
}
