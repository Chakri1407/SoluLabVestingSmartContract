// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract vestingContract {
    event VestingStarted(uint256 timestamp);
    event BeneficiaryAdded(address role, uint256 amount);
    event TokensReleased(address beneficiary, uint256 amount);

    // we will be assigning all roles in constructor
    address public immutable USER_ROLE;
    address public immutable PARTNER_ROLE;
    address public immutable TEAM_ROLE;

    // to keep track of vesting details
    struct VestingSchedule {
        uint256 Cliff; // cliff duration
        uint256 Start; // start of vesting schedule
        uint256 Duration; // Duration of vesting
        uint256 Amount; // amount for each role
        uint256 Released; // amount released till now
    }

    // token will be set in constructor and remains constant
    IERC20 public immutable token;
    bool public vestingStarted;
    address public owner;

    // we map each role to a vestingSchedule
    mapping(address => VestingSchedule) public schedules;
    //to confirm whether each address has a role
    mapping(address => bool) public hasRole;

    constructor(
        address _token,
        address _owner,
        address _USER_ROLE,
        address _PARTNER_ROLE,
        address _TEAM_ROLE
    ) {
        token = IERC20(_token);
        vestingStarted = false;
        owner = _owner;
        USER_ROLE = _USER_ROLE;
        PARTNER_ROLE = _PARTNER_ROLE;
        TEAM_ROLE = _TEAM_ROLE;

    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not an Admin");
        _;
    }

    modifier onlyBeneficiary() {
        require(hasRole[msg.sender], "Caller is not a Beneficiary");
        _;
    }

    function addBeneficiary(address role) public onlyOwner {
        require(!vestingStarted, "Vesting already started");
        require(role != address(0), "Beneficiary cannot be address zero");

        // we set cliff, duration and amount
        uint256 cliff;
        uint256 duration;
        uint amount;
        uint tokenBalance = token.balanceOf(address(this));

        // just for this assigment we are considering every month has 30 days and we are assigning cliff and duration
        // to each role
        if (role == USER_ROLE) {
            cliff = 10 * 30 days;
            duration = 2 * 12 * 30 days;
            amount = tokenBalance / 2;
        } else if (role == PARTNER_ROLE) {
            cliff = 2 * 30 days;
            duration = 12 * 30 days;
            amount = tokenBalance / 4;
        } else if (role == TEAM_ROLE) {
            cliff = 2 * 30 days;
            duration = 12 * 30 days;
            amount = tokenBalance / 4;
        } else {
            revert("Invaid Role");
        }

        schedules[role] = VestingSchedule({
            Cliff: cliff,
            Start: 0,
            Duration: duration,
            Amount: amount,
            Released: 0
        });
        hasRole[role] = true;
        emit BeneficiaryAdded(role, amount);
    }
 
    // we start vesting and only owner has access to start it by initializing the start time for all roles
    function startVesting() public onlyOwner { 
        require(!vestingStarted, "Vesting already started");
        vestingStarted = true;
        uint256 startTime = block.timestamp;

        schedules[USER_ROLE].Start = startTime;
        schedules[PARTNER_ROLE].Start = startTime;
        schedules[TEAM_ROLE].Start = startTime;
        emit VestingStarted(startTime);
    }
  
    // after the completion of cliff period beneficiary can withdraw his funds by also updating the vested amount and released amount 
    function releaseTokens() public onlyBeneficiary {
        VestingSchedule storage schedule = schedules[msg.sender];
        require(schedule.Start > 0, "Vesting not started for beneficiary");
        require(schedule.Cliff > block.timestamp, "Cliff period not completed");

        uint256 vested = vestedAmount(msg.sender, block.timestamp);
        uint256 unreleased = vested - schedule.Released;
        require(unreleased > 0, " No Tokens are due");

        schedule.Released += unreleased;
        token.transfer(msg.sender, unreleased);
        emit TokensReleased(msg.sender, unreleased);
    }
 
    // Below function is called releaseTokens which gives the vested amount for that particluar duration
    function vestedAmount(
        address beneficiary,
        uint256 time
    ) internal view returns (uint256) {
        VestingSchedule storage schedule = schedules[beneficiary];

        if (time < schedule.Start + schedule.Cliff) {
            return 0;
        } else if (time >= schedule.Start + schedule.Duration) {
            return schedule.Amount;
        } else {
            return
                (schedule.Amount * (time - schedule.Start)) / schedule.Duration;
        }
    }
    
    // To know the balance of the token we use 
    function tokenBalanceOfContract() public view returns (uint) {
        return token.balanceOf(address(this));
    }
}
