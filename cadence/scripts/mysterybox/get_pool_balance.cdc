import MysteryBox from "../../contracts/MysteryBox.cdc"

pub fun main(tokenName: String):UFix64{
	let account = getAccount(Address(0xc3cb13a49438c846))
	let mybox = account.getCapability(MysteryBox.MysteryBoxControllerPublicPath)!.borrow<&{MysteryBox.MysteryBoxControllerPublic}>()?? panic("Unable to borrow MysteryBox Public!")
	return mybox.getPrizePoolBalance(tokenName: tokenName)
}