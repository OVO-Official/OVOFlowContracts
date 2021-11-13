import OVOMarketPlace from "../../contracts/OVOMarketPlace.cdc"

pub fun main(orderId: UInt64):OVOMarketPlace.orderData? {
	let account = getAccount(0xb8c9719934dc4ff1)
	let cap = account
	.getCapability<&{OVOMarketPlace.MarketPublic}>(OVOMarketPlace.MarketPublicPath)
	.borrow()?? panic("Can not borrow market cap!")
	return cap.getMarketOrder(orderId: orderId)
}