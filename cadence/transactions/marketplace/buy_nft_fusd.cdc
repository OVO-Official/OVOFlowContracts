import OVOMarketPlace from "../../contracts/OVOMarketPlace.cdc"
import FungibleToken from "../../contracts/FungibleToken.cdc"
import FUSD from "../../contracts/FUSD.cdc"
import NyatheesOVO from "../../contracts/NyatheesOVO.cdc"

transaction (orderId: UInt64, tokenName: String, totalPrice: UFix64) {

	let buyerTokenVault: @FungibleToken.Vault
	let adminCap: &{OVOMarketPlace.MarketPublic}
	let buyerAddr: Address
	prepare(acct: AuthAccount) {
		let vaultRef = acct.borrow<&FUSD.Vault>(from: /storage/fusdVault)
      	?? panic("Could not borrow reference to the owner's Vault!")
		if (vaultRef.balance < totalPrice){
			panic("not enough money")
		}
		self.buyerAddr = acct.address
		self.buyerTokenVault <- vaultRef.withdraw(amount: totalPrice)
		var adminAccount = getAccount(Address(0xc3cb13a49438c846))
		self.adminCap = adminAccount.getCapability(OVOMarketPlace.MarketPublicPath)
											.borrow<&{OVOMarketPlace.MarketPublic}>() ?? panic("Can not borrow market cap")
	}
	execute {
		self.adminCap.buyNFT(orderId: orderId, buyerAddr: self.buyerAddr, 
							 tokenName: tokenName, buyerTokenVault: <-self.buyerTokenVault)
	}
}