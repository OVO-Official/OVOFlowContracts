import MysteryBox from "../../contracts/MysteryBox.cdc"

pub fun main():UInt64 {
	let account = getAccount(Address(0xd0da13029b214ac5))
	let mybox = account.getCapability(MysteryBox.MysteryBoxControllerPublicPath)!.borrow<&{MysteryBox.MysteryBoxControllerPublic}>()?? panic("Unable to borrow MysteryBox Public!")
	return mybox.getTotalSupply()
}