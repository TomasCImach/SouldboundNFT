# Ethernaut Bounty Commit

## Specs
Mintable NFT, nontransferable capable of reading and displaying how many EXP tokens you have in your wallet
- Create a fully on-chain generative ASCII art showing numbers from 1 to 100
- All mints start with the number 0
- The number shown by the NFT must reflect the EXP balance of the owner on the NFT
- Transfer capabilities must be disabled after minting (soulbound)

## Links
- Testnet Opensea: https://testnets.opensea.io/collection/soulbound-ascii-v3
- Rinkeby Etherscan: https://rinkeby.etherscan.io/address/0xa83a482b618a42d75e240930e9fe9eba60555648

## Currently working with demo ERC20
- Get some faucet ERC20 from https://erc20faucet.com/
- Mint one NFT on etherscan (function 2)
- Call updateAllUris() function on etherscan (funtion 11)
- Refresh metadata on Opensea and wait a couple of minutes