## Proxy contract

In the repo, trying to implement and test upgradable proxy contract.**

### Practice 1
- UpgradeableProxy.sol
- TradingCenter.sol: version 1 contract with exchange function to transfer USDT or USDC
- TradingCenterV2.sol: version 2 contract with malicious empty function to rub all users' money
- TradingCenterTest.t.sol
  
  * user1, user2 approve to proxy contract
  * upgrade version 1 contract to version 2
  * Initialize TradingCenterV2
  * empty users' account
 
### practice 2
- FiatTokenV3.sol:
  
  * mimick to upgrade USDC contract
  * with new whitelist function that both mint() and transfer() require msg.sender who is in the whitelist to call
  * require to preserve the same slots as FiatTokenV2_1 at first
    
- FiatTokenV3Test.t.sol:

  * set users as leaf to implement merkle tree function and get root and proof
  * fork the ethereum mainnet
  * get admin address through ADMIN_SLOT
  * upgrade the proxy pointer from V2_1 to V3
  * check contract version()
  * test mint() and transfer()

## Documentation

Environment: foundry

https://book.getfoundry.sh/

## Build

#### 1. download fuundry
```
curl -L https://foundry.paradigm.xyz | bash
```
#### 2. install or update foundry
```
foundryup
```
#### 3. create new project
```
forge init [project name]
```
#### 4. install openzepplin
```
forge install openzeppelin/openzeppelin-contracts --no-commit
```
#### 5. install Merkle
```
forge install dmfxyz/murky --no-commit
```
#### 6. add dependencies and path
```
forge remappings > remappings.txt
```

## Test

#### 1. download the git
```
git clone https://github.com/Rita94105/proxy.git
```
#### 2. adjust the path

```
cd proxy
```

#### 3. test Practice 1

```
forge test --mc TradingCenter
```

- test result

![TradingCenter_testResut](https://github.com/Rita94105/proxy/blob/master/img/TradingCenter_result.png)

#### 4. test Practice 2

```
forge test --mc FiatTokenV3 
```

- test result

![FiatTokenV3_testResut](https://github.com/Rita94105/proxy/blob/master/img/FiatTokenV3_result.png)

