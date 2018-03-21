pragma solidity ^0.4.15;

import "./ERC20Token.sol";
import "./TokenHolder.sol";


contract GPToken is ERC20Token, TokenHolder {

    uint256 constant public GPT_UNIT = 10 ** 18;
    uint256 public totalSupply = 150 * 10**6 * GPT_UNIT;                        // Total supply of 150 milion tokens

    uint256 constant public CROWDSALE_ALLOCATION = 87 * 10**6 * GPT_UNIT;       // Crowdsale Allocation 58%
    uint256 constant public MARKETING_ALLOCATION = 15 * 10**6 * GPT_UNIT;       // Incentivisation Allocation 10%
    uint256 constant public ADVISORS_ALLOCATION = 3 * 10**6 * GPT_UNIT;         // Advisors Allocation 2%
    uint256 constant public TEAM_ALLOCATION = 45 * 10**6 * GPT_UNIT;            // Team allocation 30%

    uint256 constant public TIMELOCK = 6 * 4 weeks;                             // Team release and unsold retrieval timelock after the end of crowdsale
    uint256 constant public ADVISORS_TIMELOCK = 2 * 4 weeks;                    // Advisor release timelock after the end of crowdsale

    address public crowdFundAddress;                                            // Address of the crowdfund
    address public advisorAddress;                                              // Advisor's address
    address public marketingFundAddress;                                        // Address that holds the marketing funds
    address public teamAddress;                                                 // Team address

    uint256 public totalAllocatedToAdvisors = 0;                                // Counter to keep track of advisor token allocation
    uint256 public totalAllocatedToTeam = 0;                                    // Counter to keep track of team token allocation
    uint256 public totalAllocated = 0;                                          // Counter to keep track of overall token allocation
    uint256 public crowdSaleEndTime = 0;

    bool internal isReleasedToPublic = false; 
    uint256 internal teamTranchesReleased = 0;                          
    uint256 internal maxTeamTranches = 4;     

    function GPToken(address _crowdFundAddress, address _advisorAddress, address _marketingFundAddress,  address _teamAddress, uint256 _durationInMinutes) ERC20Token("Game Protocol Token", "GPT", 18) public {
        crowdFundAddress = _crowdFundAddress;
        advisorAddress = _advisorAddress;
        teamAddress = _teamAddress;
        crowdSaleEndTime = now + _durationInMinutes * 1 minutes;
        marketingFundAddress = _marketingFundAddress;
        balanceOf[_crowdFundAddress] = CROWDSALE_ALLOCATION;                                // Total presale + crowdfund tokens
        balanceOf[_marketingFundAddress] = MARKETING_ALLOCATION;                            // 10% Allocated for Marketing and Incentivisation
        totalAllocated += MARKETING_ALLOCATION;                                             // Add to total Allocated funds
    }

    function getTime() internal constant returns(int) {
        return int(now - crowdSaleEndTime);
    }

    function getTeamTranchesReleased() internal constant returns(uint256) {
        return teamTranchesReleased;
    }

    /**
        @dev send coins
        throws on any error rather then return a false flag to minimize user errors
        in addition to the standard checks, the function throws if transfers are disabled

        @param _to      target address
        @param _value   transfer amount

        @return true if the transfer was successful, throws if it wasn't
    */
    function transfer(address _to, uint256 _value) public returns (bool success) {
        if (isTransferAllowed() == true || msg.sender == crowdFundAddress || msg.sender == marketingFundAddress) {
            assert(super.transfer(_to, _value));
            return true;
        }
        revert();        
    }

    /**
        @dev an account/contract attempts to get the coins
        throws on any error rather then return a false flag to minimize user errors
        in addition to the standard checks, the function throws if transfers are disabled

        @param _from    source address
        @param _to      target address
        @param _value   transfer amount

        @return true if the transfer was successful, throws if it wasn't
    */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if (isTransferAllowed() == true || msg.sender == crowdFundAddress || msg.sender == marketingFundAddress) {        
            assert(super.transferFrom(_from, _to, _value));
            return true;
        }
        revert();
    }
    
    /**
        @dev Release one single tranche of the Team Token allocation
        throws if before timelock (6 months) ends and if not initiated by the owner of the contract
        returns true if valid
        Schedule goes as follows:
        3 months: 25% (this tranche can only be released after the initial 6 months has passed)
        6 months: 25%
        9 months: 25%
        12 months: 25%
        @return true if successful, throws if not
    */
    function releaseTeamTokens() public safeTimelock ownerOnly returns(bool success) {
        require(totalAllocatedToTeam < TEAM_ALLOCATION);

        uint256 teamAlloc = TEAM_ALLOCATION / 100;
        uint part = 100 / maxTeamTranches;
        uint256 currentTranche = uint256(now - crowdSaleEndTime - TIMELOCK) / 12 weeks;     // "months" after crowdsale end time (division floored)

        if (teamTranchesReleased < maxTeamTranches && currentTranche >= teamTranchesReleased) {
            teamTranchesReleased++;

            uint256 amount = safeMul(teamAlloc, part);
            balanceOf[teamAddress] = safeAdd(balanceOf[teamAddress], amount);
            Transfer(0x0, teamAddress, amount);
            totalAllocated = safeAdd(totalAllocated, amount);
            totalAllocatedToTeam = safeAdd(totalAllocatedToTeam, amount);
            return true;
        }
        revert();
    }

    /**
        @dev release Advisors Token allocation
        throws if before timelock (2 months) ends or if no initiated by the advisors address
        or if there is no more allocation to give out
        returns true if valid

        @return true if successful, throws if not
    */
    function releaseAdvisorTokens() public advisorTimelock ownerOnly returns(bool success) {
        require(totalAllocatedToAdvisors == 0);
        balanceOf[advisorAddress] = safeAdd(balanceOf[advisorAddress], ADVISORS_ALLOCATION);
        totalAllocated = safeAdd(totalAllocated, ADVISORS_ALLOCATION);
        totalAllocatedToAdvisors = ADVISORS_ALLOCATION;
        Transfer(0x0, advisorAddress, ADVISORS_ALLOCATION);
        return true;
    }

    /**
        @dev Retrieve unsold tokens from the crowdfund
        throws if before timelock (6 months from end of Crowdfund) ends and if no initiated by the owner of the contract
        returns true if valid

        @return true if successful, throws if not
    */
    function retrieveUnsoldTokens() public safeTimelock ownerOnly returns(bool success) {
        uint256 amountOfTokens = balanceOf[crowdFundAddress];
        balanceOf[crowdFundAddress] = 0;
        balanceOf[marketingFundAddress] = safeAdd(balanceOf[marketingFundAddress], amountOfTokens);
        totalAllocated = safeAdd(totalAllocated, amountOfTokens);
        Transfer(crowdFundAddress, marketingFundAddress, amountOfTokens);
        return true;
    }

    /**
        @dev Keep track of token allocations
        can only be called by the crowdfund contract
    */
    function addToAllocation(uint256 _amount) public crowdfundOnly {
        totalAllocated = safeAdd(totalAllocated, _amount);
    }

    /**
        @dev Function to allow transfers
        can only be called by the owner of the contract
        Transfers will be allowed regardless after the crowdfund end time.
    */
    function allowTransfers() public ownerOnly {
        isReleasedToPublic = true;
    } 

    /**
        @dev User transfers are allowed/rejected
        Transfers are forbidden before the end of the crowdfund
    */
    function isTransferAllowed() internal constant returns(bool) {
        if (now > crowdSaleEndTime || isReleasedToPublic == true) {
            return true;
        }
        return false;
    }

    // Team timelock    
    modifier safeTimelock() {
        require(now >= crowdSaleEndTime + TIMELOCK);
        _;
    }

    // Advisor Team timelock    
    modifier advisorTimelock() {
        require(now >= crowdSaleEndTime + ADVISORS_TIMELOCK);
        _;
    }

    // Function only accessible by the Crowdfund contract
    modifier crowdfundOnly() {
        require(msg.sender == crowdFundAddress);
        _;
    }
}