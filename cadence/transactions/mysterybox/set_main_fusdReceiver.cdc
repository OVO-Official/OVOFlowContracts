// import MysteryBox from "../../contracts/MysteryBox.cdc"

import MysteryBox from 0xe07dd4765b2ede83
import NyatheesOVO from 0xe07dd4765b2ede83

transaction(receiverAddr: Address) {
	let admin: &{MysteryBox.MysteryBoxControlllerPrivate}
	prepare(account: AuthAccount) {
		
        self.admin = account.borrow<&{MysteryBox.MysteryBoxControlllerPrivate}>(from: MysteryBox.MysteryBoxControlllerStoragePath) ?? panic("Could not borrow admin client")
	} 
	execute {
        self.admin.setMainFusdReceiver(mainFusdReceiverAddr: receiverAddr)
    }
}