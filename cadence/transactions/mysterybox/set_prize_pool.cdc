// import MysteryBox from "../../contracts/MysteryBox.cdc"

import MysteryBox from 0xe07dd4765b2ede83

transaction(tokenName: String, amount: UFix64) {
	let admin: &{MysteryBox.MysteryBoxControlllerPrivate}
	prepare(account: AuthAccount) {
		
        self.admin = account.borrow<&{MysteryBox.MysteryBoxControlllerPrivate}>(from: MysteryBox.MysteryBoxControlllerStoragePath) ?? panic("Could not borrow admin client")
	} 
	execute {
        self.admin.setPrizePool(tokenName: tokenName, amount: amount)
    }
}
 