// import MysteryBox from "../../contracts/MysteryBox.cdc"
// import NyatheesOVO from "../../contracts/NyatheesOVO.cdc"
//Testnet
import MysteryBox from 0xe07dd4765b2ede83
import NyatheesOVO from 0xe07dd4765b2ede83

// Mainnet
// import FungibleToken from 0xf233dcee88fe0abe
// import FUSD from 0x3c5959b568896393

// Testnet
import FungibleToken from 0x9a0766d93b6608b7
import FUSD from 0xe223d8a629e49c68

transaction(mysteryBoxTypeId: UInt64, referrerAddr: Address, tokenName: String, mysteryBoxAmount: UInt64) {
	let buyerAddress: Address
    let mysteryboxCap: &{MysteryBox.MysteryBoxControlllerPublic}
    let paymentVault: @FungibleToken.Vault
	prepare(account: AuthAccount) {
        self.buyerAddress = account.address
        let mainFUSDVault = account.borrow<&FUSD.Vault>(from: /storage/fusdVault)
            ?? panic("Cannot borrow FUSD vault from account storage")
        var ownerAccount = getAccount(Address(0xe07dd4765b2ede83))

        self.mysteryboxCap = ownerAccount.getCapability(MysteryBox.MysteryBoxControlllerPublicPath)!
                                                        .borrow<&{MysteryBox.MysteryBoxControlllerPublic}>()?? panic("Unable to borrow MysteryBox Public!")

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
        // self.mysteryboxCap = ownerAccount.borrow<&{MysteryBox.MysteryBoxControlllerPublic}>(from: MysteryBox.MysteryBoxControlllerStoragePath) ?? panic("Could not borrow MysteryboxCap")
        
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