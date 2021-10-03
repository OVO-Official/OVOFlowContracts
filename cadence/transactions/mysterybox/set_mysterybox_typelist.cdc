import MysteryBox from "../../contracts/MysteryBox.cdc"

transaction(typeId: UInt64, describe: String, stock: UInt64, unitPrice: UFix64) {
	let admin: &{MysteryBox.MysteryBoxControllerPrivate}
	prepare(account: AuthAccount) {
		
        self.admin = account.borrow<&{MysteryBox.MysteryBoxControllerPrivate}>(from: MysteryBox.MysteryBoxControllerStoragePath) ?? panic("Could not borrow admin client")
	} 
	execute {
        self.admin.setMysteryBoxTypeToList(typeId: typeId, describe: describe, stock: stock, unitPrice: unitPrice) 
    }
}
 