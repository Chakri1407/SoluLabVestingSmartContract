
# Vesting Contract

This Solidity smart contract handles token vesting with predefined roles: User, Partner, and Team. Each role has a specific vesting schedule, including a cliff period and a vesting duration. The contract ensures tokens are released to the beneficiaries according to the vesting schedule.

# Contract Overview
## Roles
- USER_ROLE: Receives 50% of total allocated tokens with a cliff of 10 months and a total vesting duration of 2 years.

- PARTNER_ROLE: Receives 25% of total allocated tokens with a cliff of 2 months and a total vesting duration of 1 year.

- TEAM_ROLE: Receives 25% of total allocated tokens with a cliff of 2 months and a total vesting duration of 1 year.

### Features:
- Allows the owner to start vesting.
- Enables the addition of beneficiaries for each role before - vesting starts.
- Allows beneficiaries to claim their vested tokens according to the schedule.
- Tracks and emits events for vesting start, beneficiary addition, and token withdrawal.

# Contract Functions
### Constructor

``` 
constructor(
    address _token,
    address _owner,
    address _USER_ROLE,
    address _PARTNER_ROLE,
    address _TEAM_ROLE
)
```
- Initializes the contract with the ERC20 token address, owner address, and addresses for the three roles.

### addBeneficiary(address role)

```
function addBeneficiary(address role) public onlyOwner
```
- Adds a beneficiary for the specified role before vesting starts.
- Roles: USER_ROLE, PARTNER_ROLE, TEAM_ROLE.
- Emits a BeneficiaryAdded event.

### startVesting()

``` 
function startVesting() public onlyOwner
```
- Starts the vesting process.
- Sets the vesting start time for all roles.
- Emits a VestingStarted event.

### releaseTokens()

``` 
function releaseTokens() public onlyBeneficiary
``` 
- Releases the vested tokens to the beneficiary calling the function.
- Ensures the cliff period has passed and calculates the amount to be released.
- Emits a TokensReleased event.

### vestedAmount(address beneficiary, uint256 time)

```
function vestedAmount(address beneficiary, uint256 time) internal view returns (uint256)

```
- Calculates the amount of vested tokens for a beneficiary at a given time.

### tokenBalanceOfContract()

```
function tokenBalanceOfContract() public view returns (uint)
```
- Returns the token balance of the contract.

# Usage
## Deploying the Contract
- Deploy the contract, providing the ERC20 token address, owner address, and addresses for USER_ROLE, PARTNER_ROLE, and TEAM_ROLE.

## Adding Beneficiaries
- Call addBeneficiary for each role to set up their vesting schedules. This must be done before starting the vesting.

## Starting Vesting 
- Call startVesting to begin the vesting process.

## Releasing Tokens
- Beneficiaries call releaseTokens after their cliff period has passed to receive their vested tokens.

## Checking Token Balance 
- Call tokenBalanceOfContract to check the token balance held by the contract.

# Events
- VestingStarted(uint256 timestamp): Emitted when vesting starts.
- BeneficiaryAdded(address role, uint256 amount): Emitted when a beneficiary is added.
- TokensReleased(address beneficiary, uint256 amount): Emitted when tokens are released to a beneficiary.


## License

[MIT](https://choosealicense.com/licenses/mit/)


## FAQ

#### Question 
For any Questions, Kindly reach me [![linkedin](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/chakravarthy-naik-9626bb1ba/)


