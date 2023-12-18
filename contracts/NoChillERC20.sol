// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC20Base.sol";

contract NoChill is ERC20Base {
    uint256 private immutable MAX_SUPPLY;

    constructor(address defaultAdmin_, string memory name_, string memory symbol_, uint256 supply_)
        ERC20Base(defaultAdmin_, name_, symbol_)
    {
        MAX_SUPPLY = supply_;
        _mint(msg.sender, supply_);
    }

    function mintTo(address _to, uint256 _amount) public override {
        require(_canMint(), "Not authorized to mint.");
        require(_amount != 0, "Minting zero tokens.");
        require(totalSupply() + _amount <= MAX_SUPPLY, "Minting exceeds max supply.");

        _mint(_to, _amount);
    }
}
