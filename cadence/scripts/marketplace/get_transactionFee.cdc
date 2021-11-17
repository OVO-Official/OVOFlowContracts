import OVOMarketPlace from "../../contracts/OVOMarketPlace.cdc"

pub fun main(tokenName: String):UFix64? {
	let account = getAccount(0xd0da13029b214ac5)
	let cap = account
	.getCapability<&{OVOMarketPlace.MarketPublic}>(OVOMarketPlace.MarketPublicPath)
	.borrow()?? panic("Can not borrow market cap!")
	return cap.getTransactionFee(tokenName: tokenName)
}