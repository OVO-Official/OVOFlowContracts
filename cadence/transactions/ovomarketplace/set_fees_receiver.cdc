import OVOMarketPlace from "../../contracts/OVOMarketPlace.cdc"

transaction (receiverAddr: Address) {

	let adminCap: &{OVOMarketPlace.MarketController}
	prepare(acct: AuthAccount) {
		self.adminCap = acct.borrow<&{OVOMarketPlace.MarketController}>(from: OVOMarketPlace.MarketControllerStoragePath) ?? panic("Can not borrow market cap")
	}
	execute {
		self.adminCap.setTransactionFeeReceiver(receiverAddr: receiverAddr)
	}
}