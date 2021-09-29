// import MysteryBox from "../../contracts/MysteryBox.cdc"

import MysteryBox from 0xe07dd4765b2ede83

transaction(typeId: UInt64, describe: String, stock: UInt64, unitPrice: UFix64) {
	let admin: &{MysteryBox.MysteryBoxControlllerPrivate}
	prepare(account: AuthAccount) {
		
        self.admin = account.borrow<&{MysteryBox.MysteryBoxControlllerPrivate}>(from: MysteryBox.MysteryBoxControlllerStoragePath) ?? panic("Could not borrow admin client")
	} 
	execute {
        self.admin.setMysteryBoxTypeToList(typeId: typeId, describe: describe, stock: stock, unitPrice: unitPrice) 
    }
}
 