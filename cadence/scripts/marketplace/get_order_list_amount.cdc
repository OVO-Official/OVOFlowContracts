import OVOMarketPlace from "../../contracts/OVOMarketPlace.cdc"

pub fun main():Int {
	let account = getAccount(0xc3cb13a49438c846)
	let cap = account
	.getCapability<&{OVOMarketPlace.MarketPublic}>(OVOMarketPlace.MarketPublicPath)
	.borrow()?? panic("Can not borrow market cap!")
	return cap.getMarketOrderList().length
}