import OVOMarketPlace from "../../contracts/OVOMarketPlace.cdc"
import FungibleToken from "../../contracts/FungibleToken.cdc"
import FUSD from "../../contracts/FUSD.cdc"
import NyatheesOVO from "../../contracts/NyatheesOVO.cdc"

transaction (orderId: UInt64) {

	let adminCap: &{OVOMarketPlace.MarketPublic}
	var sellerAddr: Address
	prepare(acct: AuthAccount) {
		var adminAccount = getAccount(Address(0xc3cb13a49438c846))
		self.adminCap = adminAccount.getCapability(OVOMarketPlace.MarketPublicPath)
											.borrow<&{OVOMarketPlace.MarketPublic}>() ?? panic("Can not borrow market cap")
		self.sellerAddr = acct.address;
	}
	execute {
		self.adminCap.cancelOrder(orderId: orderId, sellerAddr: self.sellerAddr)
	}
}