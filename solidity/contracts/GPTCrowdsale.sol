pragma solidity ^0.4.23;

import "./GPToken.sol";
import "./crowdsale/distribution/FinalizableCrowdsale.sol";
import "./crowdsale/emission/MintedCrowdsale.sol";
import "./crowdsale/validation/WhitelistedCrowdsale.sol";
import "./crowdsale/validation/CappedTokenCrowdsale.sol";
import "./GPTTeamTokenTimelock.sol";
import "./crowdsale/Crowdsale.sol";

import "./GPToken.sol";

/**
 * @title GPTCrowdsale
 * @dev Game Protocol Crowdsale contract.
 * The way to add new features to a base crowdsale is by multiple inheritance.
 * In this example we are providing following extensions:
 *
 * After adding multiple features it's good practice to run integration tests
 * to ensure that subcontracts works together as intended.
 */
contract GPTCrowdsale is FinalizableCrowdsale, MintedCrowdsale, WhitelistedCrowdsale, CappedTokenCrowdsale {

    uint256 constant public GPT_UNIT = 10 ** 18;
    uint256 constant public TOTAL_SUPPLY = 150 * 10**6 * GPT_UNIT;                          // Total supply of 150 milion tokens

    uint256 constant public CROWDSALE_ALLOCATION = 87 * 10**6 * GPT_UNIT;                   // Crowdsale Allocation 58%
    uint256 constant public GAME_SUPPORT_FUND_ALLOCATION = 15 * 10**6 * GPT_UNIT;           // Game support fund Allocation 10%
    uint256 constant public BOUNTY_PROGRAM_ALLOCATION = 3 * 10**6 * GPT_UNIT;               // Bounty program Allocation 2%
    uint256 constant public ADVISORS_AND_PARTNERSHIP_ALLOCATION = 15 * 10**6 * GPT_UNIT;    // Advisors and partnership Allocation 10%
    uint256 constant public TEAM_ALLOCATION = 30 * 10**6 * GPT_UNIT;                        // Team allocation 20%

    address public walletGameSupportFund;                                                   // Address that holds the advisors tokens
    address public walletBountyProgram;                                                     // Address that holds the marketing tokens
    address public walletAdvisorsAndPartnership;                                            // Address that holds the advisors tokens
    address public walletTeam;                                                              // Address that holds the team tokens


    constructor (
        uint256 _openingTime,
        uint256 _closingTime,
        uint256 _rate,
        address _wallet,
        address _walletGameSupportFund, 
        address _walletBountyProgram,
        address _walletAdvisorsAndPartnership, 
        address _walletTeam, 
        GPToken _token
    ) 
        public
        Crowdsale(_rate, _wallet, _token)
        TimedCrowdsale(_openingTime, _closingTime)
        CappedTokenCrowdsale(CROWDSALE_ALLOCATION)
    {
        require(_walletGameSupportFund != address(0));
        require(_walletBountyProgram != address(0));
        require(_walletAdvisorsAndPartnership != address(0));
        require(_walletTeam != address(0));

        walletGameSupportFund = _walletGameSupportFund;
        walletBountyProgram = _walletBountyProgram;
        walletAdvisorsAndPartnership = _walletAdvisorsAndPartnership;
        walletTeam = _walletTeam;
    }

    // Helper function to add a percent of the value to a value
    function addPercent(uint8 percent, uint256 value) internal pure returns(uint256) {
        return value.add(value.mul(percent).div(100));
    }

    // =================================================================================================================
    //                                      Impl Crowdsale
    // =================================================================================================================

    /**
     * @return the token amount according to the time of the tx and the GPT pricing program.
     */
    function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
        // solium-disable-next-line security/no-block-members
        if (now < (closingTime.sub(4 weeks))) {
            return _weiAmount.mul(addPercent(20, rate)); 
        }
        // solium-disable-next-line security/no-block-members
        if (now < (closingTime.sub(3 weeks))) {
            return _weiAmount.mul(addPercent(15, rate)); 
        }
        // solium-disable-next-line security/no-block-members
        if (now < (closingTime.sub(2 weeks))) {
            return _weiAmount.mul(addPercent(10, rate)); 
        }
        // solium-disable-next-line security/no-block-members
        if (now < (closingTime.sub(1 weeks))) {
            return _weiAmount.mul(addPercent(5, rate)); 
        }
        return _weiAmount.mul(rate);
    }

    // =================================================================================================================
    //                                      Impl FinalizableCrowdsale
    // =================================================================================================================

    function finalization() internal onlyOwner {
        super.finalization();

        // 20% of the total number of GPT tokens will be allocated to the team
        // create a timed wallet that will release the tokens every 6 months
        GPTTeamTokenTimelock timelock = new GPTTeamTokenTimelock(token, walletTeam, closingTime);
        _deliverTokens(address(timelock), TEAM_ALLOCATION);

        // _deliverTokens(walletTeam, TEAM_ALLOCATION); // TODO: replace 

        // 10% of the total number of GPT tokens will be allocated to the game support fund
        _deliverTokens(walletGameSupportFund, GAME_SUPPORT_FUND_ALLOCATION);

        // 2% of the total number of GPT tokens will be allocated to the bounty program
        _deliverTokens(walletBountyProgram, BOUNTY_PROGRAM_ALLOCATION);

        // 10% of the total number of GPT tokens will be allocated to the advisors and partnership
        _deliverTokens(walletAdvisorsAndPartnership, ADVISORS_AND_PARTNERSHIP_ALLOCATION);

        // The ramaining tokens that ware not sold in the crowdsale will be sent to a game support fund
        // TODO: or burned?
        uint256 tokensLeft = CROWDSALE_ALLOCATION - tokensAllocated; //remainingTokens();
        _deliverTokens(walletGameSupportFund, tokensLeft);

        GPToken(token).finishMinting();

        // Re-enable transfers and burn after the token sale.
        GPToken(token).unpause();

        GPToken(token).transferOwnership(owner);
    }
}