// This script returns the balance of an account's FUSD vault.
//
// Parameters:
// - address: The address of the account holding the FUSD vault.
//
// This script will fail if they account does not have an FUSD vault. 
// To check if an account has a vault or initialize a new vault, 
// use check_fusd_vault_setup.cdc and setup_fusd_vault.cdc respectively.

// import FungibleToken from "../../contracts/FungibleToken.cdc"
// import FUSD from "../../contracts/FUSD.cdc"

// Mainnet
// import FungibleToken from 0xf233dcee88fe0abe
// import FUSD from 0x3c5959b568896393

// Testnet
import FungibleToken from 0x9a0766d93b6608b7
import FUSD from 0xe223d8a629e49c68

pub fun main(address: Address): UFix64 {
    let account = getAccount(address)

    let vaultRef = account.getCapability(/public/fusdBalance)!
        .borrow<&FUSD.Vault{FungibleToken.Balance}>()
        ?? panic("Could not borrow Balance reference to the Vault")

    return vaultRef.balance
}
