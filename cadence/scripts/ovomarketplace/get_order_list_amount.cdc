import OVOMarketPlace from "../../contracts/OVOMarketPlace.cdc"

pub fun main():Int {
	// test net
	// let account = getAccount(0xd0da13029b214ac5)
	// main net
	let account = getAccount(0x75e0b6de94eb05d0)
	let cap = account
	.getCapability<&{OVOMarketPlace.MarketPublic}>(OVOMarketPlace.MarketPublicPath)
	.borrow()?? panic("Can not borrow market cap!")
	return cap.getMarketOrderList().length
}