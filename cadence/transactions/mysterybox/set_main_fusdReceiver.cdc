import MysteryBox from "../../contracts/MysteryBox.cdc"
import NyatheesOVO from "../../contracts/NyatheesOVO.cdc"

transaction(receiverAddr: Address) {
	let admin: &{MysteryBox.MysteryBoxControllerPrivate}
	prepare(account: AuthAccount) {
		
        self.admin = account.borrow<&{MysteryBox.MysteryBoxControllerPrivate}>(from: MysteryBox.MysteryBoxControllerStoragePath) ?? panic("Could not borrow admin client")
	} 
	execute {
        self.admin.setMainFusdReceiver(mainFusdReceiverAddr: receiverAddr)
    }
}