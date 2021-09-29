// import FungibleToken from "../../contracts/FungibleToken.cdc"
// import FUSD from "../../contracts/FUSD.cdc"

// Mainnet
// import FungibleToken from 0xf233dcee88fe0abe
// import FUSD from 0x3c5959b568896393

// Testnet
import FungibleToken from 0x9a0766d93b6608b7
import FUSD from 0xe223d8a629e49c68

pub fun main():UFix64 {
	return FUSD.totalSupply
}