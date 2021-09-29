// import MysteryBox from "../../contracts/MysteryBox.cdc"
import MysteryBox from 0xe07dd4765b2ede83

pub fun main(tokenName: String):UFix64{
	let account = getAccount(Address(0xe07dd4765b2ede83))
	let mybox = account.getCapability(MysteryBox.MysteryBoxControlllerPublicPath)!.borrow<&{MysteryBox.MysteryBoxControlllerPublic}>()?? panic("Unable to borrow MysteryBox Public!")
	return mybox.getPrizePoolBalance(tokenName: tokenName)
}