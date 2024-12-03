## ERC-721

**Deployed BasicNft contract on Sepolia:** [0x60e1c41Bacf44D64d1c4Eaa559F45b6a5890C4ff](https://sepolia.etherscan.io/address/0x60e1c41Bacf44D64d1c4Eaa559F45b6a5890C4ff)

**Deployed MoodNft contract on Sepolia:** [0x53EEd37A1a992A73A694A2bC2fC04198eC4B2d03](https://sepolia.etherscan.io/address/0x53EEd37A1a992A73A694A2bC2fC04198eC4B2d03)

---

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
