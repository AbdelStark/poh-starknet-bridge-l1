<div align="center">
  <h1 align="center">poh-starknet-bridge-l1</h1>
  <p align="center">
    <a href="https://github.com/abdelhamidbakhta">
        <img src="https://img.shields.io/badge/Github-4078c0?style=for-the-badge&logo=github&logoColor=white">
    </a>
    <a href="https://twitter.com/intent/follow?screen_name=dimahledba">
        <img src="https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white">
    </a>       
  </p>
  <h3 align="center">Proof Of Humanity StarkNet bridge L1 smart contracts.</h3>
</div>

> ## ⚠️ WARNING! ⚠️
>
> This repo contains highly experimental code.
> Expect rapid iteration.
> **Use at your own risk.**

## Description

Proof Of Humanity is an Ethereum protocol aiming to create a sybil-resistant list of humans. This enable a lot of use cases around decentralized IDs, antispam tools, DAOs, ...

This StarkNet bridge enable users registerd on Proof Of Humanity to register their identity on StarkNet L2.

Dapps on StarkNet could then use those informations to unlock some of the features enabled by the protocol.

To register to StarkNet L2, a human on registered on Proof Of Humanity must invoke a function on the bridge smart contract. The smart contract then checks if the address is registered using Proof Of Humanity proxy contract.

An L2 message is then sent to the counterpart StarkNet contract and the user will be registered on L2.

> ## ⚠️ Important note ⚠️
>
> There is no way to automatically revoke the registration when it is expired on L1.
> The timestamp of the registration call on the bridge is sent to the L2 and stored in the counterpart contract.
> A dapp could use this information to check the last time the L1 contract has verified that the human was registered.
> There is a notion of expiration of the registration. The problem is that there is no way to get this information using the PoH proxy contract.
> A solution would be to call directly the last version of Proof Of Humanity contract but the problem is that there is no guarantee that the interface wont change for future versions.
> Another option would be to add a function in the brige contract to change the targeted address, however it would introduce a "backdoor" for the owner to arbitrarily switch to a fake malicious contract.

## 🏄‍♂️ Usage

### Flow

![Flow](resources/img/PoH-bridge-register-on-L2.png)

## Set up the project

### 📦 Install the requirements

- [foundry](https://book.getfoundry.sh/)

## ⛏️ Compile

```bash
forge build
```

## 🌡️ Test

```bash
forge test
```

## 📄 License

**poh-starknet-bridge-l1** is released under the [MIT](LICENSE).
