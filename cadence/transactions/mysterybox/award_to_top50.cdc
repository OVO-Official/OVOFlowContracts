// import MysteryBox from "../../contracts/MysteryBox.cdc"
// import NyatheesOVO from "../../contracts/NyatheesOVO.cdc"
import MysteryBox from 0xe07dd4765b2ede83
import NyatheesOVO from 0xe07dd4765b2ede83

// import FungibleToken from "../../contracts/FungibleToken.cdc"
// import FUSD from "../../contracts/FUSD.cdc"

// Mainnet
// import FungibleToken from 0xf233dcee88fe0abe
// import FUSD from 0x3c5959b568896393

// Testnet
import FungibleToken from 0x9a0766d93b6608b7
import FUSD from 0xe223d8a629e49c68

transaction(round: UInt64,
            addresses: [Address],
            tokenName: String,
            amounts: [UFix64],
            total: UFix64) {
    let payerAddr: Address
    let paymentVault: @FungibleToken.Vault
    let admin: &{MysteryBox.MysteryBoxControlllerPrivate}
	prepare(account: AuthAccount) {
		self.payerAddr = account.address
        let paymentFusdVault = account.borrow<&FUSD.Vault>(from: /storage/fusdVault)
            ?? panic("Cannot borrow FUSD vault from account storage")

        self.paymentVault <- paymentFusdVault.withdraw(amount: total)
        self.admin = account.borrow<&{MysteryBox.MysteryBoxControlllerPrivate}>(from: MysteryBox.MysteryBoxControlllerStoragePath)
            ?? panic("Cannot borrow FUSD vault from account storage")
    }
	execute {
        self.admin.awardToTop50(round: round,
                                addresses: addresses,
                                tokenName: tokenName,
                                amounts: amounts,
                                total: total,
                                paymentVault: <-self.paymentVault,
                                payer: self.payerAddr)
    }
}