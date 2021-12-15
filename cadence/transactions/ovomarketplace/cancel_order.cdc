import OVOMarketPlace from "../../contracts/OVOMarketPlace.cdc"
import FungibleToken from "../../contracts/FungibleToken.cdc"
import FUSD from "../../contracts/FUSD.cdc"
import NyatheesOVO from "../../contracts/NyatheesOVO.cdc"

transaction (orderId: UInt64) {

	let adminCap: &{OVOMarketPlace.MarketPublic}
	var sellerAddr: Address
	prepare(acct: AuthAccount) {
		// test net
		// var adminAccount = getAccount(Address(0xd0da13029b214ac5))
		// main net
		var adminAccount = getAccount(Address(0x75e0b6de94eb05d0))
		self.adminCap = adminAccount.getCapability(OVOMarketPlace.MarketPublicPath)
											.borrow<&{OVOMarketPlace.MarketPublic}>() ?? panic("Can not borrow market cap")
		self.sellerAddr = acct.address;
	}
	execute {
		self.adminCap.cancelOrder(orderId: orderId, sellerAddr: self.sellerAddr)
	}
}