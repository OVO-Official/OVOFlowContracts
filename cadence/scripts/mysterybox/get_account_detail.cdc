import MysteryBox from "../../contracts/MysteryBox.cdc"

pub fun main(addr: Address): MysteryBox.accountItem?{
	let account = getAccount(Address(0xb8c9719934dc4ff1))
	let mybox = account.getCapability(MysteryBox.MysteryBoxControllerPublicPath)!.borrow<&{MysteryBox.MysteryBoxControllerPublic}>()?? panic("Unable to borrow MysteryBox Public!")
	return mybox.getAccountItem(address:addr)
}