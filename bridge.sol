// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract EthBridge {
    address public admin;
    IERC20 public token;
    uint256 public nonce;

    event TokensLocked(address sender, uint256 amount, uint256 nonce);
    event TokensUnlocked(address recipient, uint256 amount, uint256 nonce);

    constructor(address tokenAddress) {
        admin = msg.sender;
        token = IERC20(tokenAddress);
    }

    function lockTokens(uint256 amount) external {
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        emit TokensLocked(msg.sender, amount, nonce);
        nonce++;
    }

    function unlockTokens(address recipient, uint256 amount) external {
        require(msg.sender == admin, "Only admin can unlock tokens");
        require(token.transfer(recipient, amount), "Transfer failed");
        emit TokensUnlocked(recipient, amount, nonce);
        nonce++;
    }

    // Add a method to withdraw tokens back to Ethereum
    function withdrawTokens(address recipient, uint256 amount) external {
        require(msg.sender == admin, "Only admin can withdraw tokens");
        require(token.transfer(recipient, amount), "Transfer failed");
        emit TokensUnlocked(recipient, amount, nonce);
        nonce++;
    }
}
