import OVOMarketPlace from "../../contracts/OVOMarketPlace.cdc"

transaction (tokenName: String, fee_percentage: UFix64) {

	let adminCap: &{OVOMarketPlace.MarketController}
	prepare(acct: AuthAccount) {
		self.adminCap = acct.borrow<&{OVOMarketPlace.MarketController}>(from: OVOMarketPlace.MarketControllerStoragePath) ?? panic("Can not borrow market cap")
	}
	execute {
		self.adminCap.setTransactionFee(tokenName: tokenName, fee_percentage: fee_percentage)
	}
}