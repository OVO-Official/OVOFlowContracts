import OVOMarketPlace from "../../contracts/OVOMarketPlace.cdc"

pub fun main(tokenName: String):UFix64? {
	let account = getAccount(0xc3cb13a49438c846)
	let cap = account
	.getCapability<&{OVOMarketPlace.MarketPublic}>(OVOMarketPlace.MarketPublicPath)
	.borrow()?? panic("Can not borrow market cap!")
	return cap.getTransactionFee(tokenName: tokenName)
}