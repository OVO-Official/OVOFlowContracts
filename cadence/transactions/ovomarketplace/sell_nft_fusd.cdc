import OVOMarketPlace from "../../contracts/OVOMarketPlace.cdc"
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import FUSD from "../../contracts/FUSD.cdc"
import NyatheesOVO from "../../contracts/NyatheesOVO.cdc"

transaction (tokenName: String, totalPrice: UFix64, tokenId: UInt64) {

	// let sellerNFT: @NonFungibleToken.NFT
	let adminCap: &{OVOMarketPlace.MarketPublic}
	let sellerNFTProvider: &NyatheesOVO.Collection{NonFungibleToken.Provider, NyatheesOVO.NFTCollectionPublic}
	let sellerAddr: Address
	prepare(acct: AuthAccount) {
		self.sellerNFTProvider = acct.borrow<&NyatheesOVO.Collection{NonFungibleToken.Provider, NyatheesOVO.NFTCollectionPublic}>(from: NyatheesOVO.CollectionStoragePath)
      	?? panic("Could not borrow reference to the owner's NFT Collection!")
		
		// test net
		// var adminAccount = getAccount(Address(0xd0da13029b214ac5))
		// main net
		var adminAccount = getAccount(Address(0x75e0b6de94eb05d0))
		self.adminCap = adminAccount.getCapability(OVOMarketPlace.MarketPublicPath)
											.borrow<&{OVOMarketPlace.MarketPublic}>() ?? panic("Can not borrow market cap")
		if (!self.sellerNFTProvider.idExists(id: tokenId)){
			panic("The NFT not belongs to you")
		}

		self.sellerAddr = acct.address;

		// self.sellerNFT <-self.sellerNFTProvider.withdraw(withdrawID: tokenId)
	}
	execute {
		self.adminCap.sellNFT(sellerAddr: self.sellerAddr, tokenName: tokenName, 
							  totalPrice: totalPrice, tokenId: tokenId, sellerNFTProvider: self.sellerNFTProvider)
	}
}