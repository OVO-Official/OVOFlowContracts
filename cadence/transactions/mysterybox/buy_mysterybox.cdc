import MysteryBox from "../../contracts/MysteryBox.cdc"
import NyatheesOVO from "../../contracts/NyatheesOVO.cdc"

import FungibleToken from "../../contracts/FungibleToken.cdc"
import FUSD from "../../contracts/FUSD.cdc"

transaction(mysteryBoxTypeId: UInt64, referrerAddr: Address, tokenName: String, mysteryBoxAmount: UInt64) {
	let buyerAddress: Address
    let mysteryboxCap: &{MysteryBox.MysteryBoxControllerPublic}
    let paymentVault: @FungibleToken.Vault
	prepare(account: AuthAccount) {
        self.buyerAddress = account.address
        let mainFUSDVault = account.borrow<&FUSD.Vault>(from: /storage/fusdVault)
            ?? panic("Cannot borrow FUSD vault from account storage")
        var ownerAccount = getAccount(Address(0xb8c9719934dc4ff1))

        self.mysteryboxCap = ownerAccount.getCapability(MysteryBox.MysteryBoxControllerPublicPath)!
                                                        .borrow<&{MysteryBox.MysteryBoxControllerPublic}>()?? panic("Unable to borrow MysteryBox Public!")

        // calculate totalPrice, if user buy 10 mysterybox, 90% discount
        if(self.mysteryboxCap.getMysteryBoxTypeItem(typeId: mysteryBoxTypeId) == nil){
            panic("Wrong MysteryBox Type")
        }
        var totalPrice = self.mysteryboxCap.getMysteryBoxTypeItem(typeId: mysteryBoxTypeId)!.unitPrice * UFix64(mysteryBoxAmount)
        if(mysteryBoxAmount == 10){
            //90% discount
            totalPrice = self.mysteryboxCap.getMysteryBoxTypeItem(typeId: mysteryBoxTypeId)!.unitPrice * UFix64(mysteryBoxAmount) * 9000000.0 / 10000000.0
        }
        self.paymentVault <- mainFUSDVault.withdraw(amount: totalPrice)
        // self.mysteryboxCap = ownerAccount.borrow<&{MysteryBox.MysteryBoxControllerPublic}>(from: MysteryBox.MysteryBoxControllerStoragePath) ?? panic("Could not borrow MysteryboxCap")
        
    }
	execute {
        self.mysteryboxCap.buyMysteryBox(mysteryBoxTypeId: mysteryBoxTypeId,
                              buyerAddr: self.buyerAddress,
                              referrerAddr: referrerAddr,
                              tokenName: tokenName,
                              mysteryBoxAmount: mysteryBoxAmount,
                              buyerTokenVault: <-self.paymentVault)
    }
}