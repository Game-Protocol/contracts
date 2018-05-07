pragma solidity ^0.4.23;

import "./token/ERC20/PausableToken.sol";
import "./token/ERC20/DetailedERC20.sol";
import "./token/ERC20/BurnableToken.sol";
import "./token/ERC20/MintableToken.sol";
import "./token/ERC20/CappedToken.sol";
import "./ownership/NoOwner.sol";

/**
 * @title GPToken
 * @dev Game Protocol Token
 * Inherited from PausableToken, BurnableToken, DetailedERC20, MintableToken, NoOwner
 * When deployed will start with a paused state until crowdsale is finished.
 */
contract GPToken is PausableToken, BurnableToken, DetailedERC20, MintableToken, NoOwner
{
    /**
    * @dev Constructor that gives msg.sender all of existing tokens.
    */
    constructor() public DetailedERC20("Game Protocol Token", "GPT", 18) {
        paused = true;
    }
}