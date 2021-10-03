import MysteryBox from "../../contracts/MysteryBox.cdc"

transaction(tokenName: String, amount: UFix64) {
	let admin: &{MysteryBox.MysteryBoxControllerPrivate}
	prepare(account: AuthAccount) {
		
        self.admin = account.borrow<&{MysteryBox.MysteryBoxControllerPrivate}>(from: MysteryBox.MysteryBoxControllerStoragePath) ?? panic("Could not borrow admin client")
	} 
	execute {
        self.admin.setPrizePool(tokenName: tokenName, amount: amount)
    }
}
 