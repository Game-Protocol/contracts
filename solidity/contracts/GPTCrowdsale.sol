pragma solidity ^0.4.15;

import './GPToken.sol';
import './TokenHolder.sol';

contract GPTCrowdsale is TokenHolder {
    uint256 public amountRaised = 0;
    uint256 public deadline = 0;

    uint256[] public prices;
    uint256[] public timeSteps;

    address public beneficiary = 0x0;
    address public tokenAddress = 0x0;
    GPToken public tokenReward;

    event Contribution(address indexed backer, uint256 amount, uint256 tokenAmount);

    /**
     * Constrctor function
     */
    function GPTCrowdsale(
        address ifSuccessfulSendTo,
        uint durationInMinutes,
        uint etherPriceInTokens,
        uint bonusWeeks,
        uint maxBonusPercent) {
            
        beneficiary = ifSuccessfulSendTo;
        deadline = now + durationInMinutes * 1 minutes; // TODO: maybe change to weeks instead of minutes (and variable durationInMinutes)

        for (uint8 i = 0; i <= bonusWeeks; i++) {
            timeSteps.push(deadline - (i + 1) * 1 weeks);
            prices.push(etherPriceInTokens + etherPriceInTokens * i * maxBonusPercent / (bonusWeeks * 100));
        }
    }

    function tokensSold() public constant returns(uint256) {
        return tokenReward.totalAllocated();
    }

    function getStep() internal constant returns (uint8) {
        for (uint8 index = 0; index < timeSteps.length - 1; index++) {
            if (now > timeSteps[index]) {
                break;
            }
        }
        return index;
    }

    function getTokenFromEther(uint256 contribution) constant returns (uint256) { //internal
        return safeMul(contribution, prices[getStep()]);
    }

    function setToken(address _tokenAddress) validAddress(_tokenAddress) ownerOnly {
        require(tokenAddress == 0x0);
        tokenAddress = _tokenAddress;
        tokenReward = GPToken(_tokenAddress);
    }

    // function changeBeneficiary(address _newBeneficiary) validAddress(_newBeneficiary) ownerOnly {
    //     beneficiary = _newBeneficiary;
    // }

    /**
     * Fallback function
     *
     * The function without name is the default function that is called whenever anyone sends funds to a contract
     */
    function () beforeDeadline tokenIsSet payable {
        uint256 tokens = getTokenFromEther(msg.value);
        beneficiary.transfer(msg.value);
        tokenReward.transfer(msg.sender, tokens);
        tokenReward.addToAllocation(tokens);
        Contribution(msg.sender, msg.value, tokens);
    }

    modifier beforeDeadline() {
        require(now < deadline);
        _; 
    }

    modifier tokenIsSet() {
        require(tokenAddress != 0x0);
        _;
    }
}