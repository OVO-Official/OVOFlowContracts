import MysteryBox from "../../contracts/MysteryBox.cdc"
import NyatheesOVO from "../../contracts/NyatheesOVO.cdc"

import FungibleToken from "../../contracts/FungibleToken.cdc"
import FUSD from "../../contracts/FUSD.cdc"

transaction(round: UInt64,
            addresses: [Address],
            tokenName: String,
            amounts: [UFix64],
            total: UFix64) {
    let payerAddr: Address
    let paymentVault: @FungibleToken.Vault
    let admin: &{MysteryBox.MysteryBoxControllerPrivate}
	prepare(account: AuthAccount) {
		self.payerAddr = account.address
        let paymentFusdVault = account.borrow<&FUSD.Vault>(from: /storage/fusdVault)
            ?? panic("Cannot borrow FUSD vault from account storage")

        self.paymentVault <- paymentFusdVault.withdraw(amount: total)
        self.admin = account.borrow<&{MysteryBox.MysteryBoxControllerPrivate}>(from: MysteryBox.MysteryBoxControllerStoragePath)
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