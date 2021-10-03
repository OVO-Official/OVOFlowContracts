import MysteryBox from "../../contracts/MysteryBox.cdc"

pub fun main(typeId: UInt64):MysteryBox.MysteryBoxType?{
	let account = getAccount(Address(0xacf3dfa413e00f9f))
	let mybox = account.getCapability(MysteryBox.MysteryBoxControllerPublicPath)!.borrow<&{MysteryBox.MysteryBoxControllerPublic}>()?? panic("Unable to borrow MysteryBox Public!")
	return mybox.getMysteryBoxTypeItem(typeId: typeId)
}