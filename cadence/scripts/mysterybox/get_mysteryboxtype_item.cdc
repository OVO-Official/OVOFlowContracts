// import MysteryBox from "../../contracts/MysteryBox.cdc"
import MysteryBox from 0xe07dd4765b2ede83

pub fun main(typeId: UInt64):MysteryBox.MysteryBoxType?{
	let account = getAccount(Address(0x609626cb09851b94))
	let mybox = account.getCapability(MysteryBox.MysteryBoxControlllerPublicPath)!.borrow<&{MysteryBox.MysteryBoxControlllerPublic}>()?? panic("Unable to borrow MysteryBox Public!")
	return mybox.getMysteryBoxTypeItem(typeId: typeId)
}