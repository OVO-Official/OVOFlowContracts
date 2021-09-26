import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import NyatheesOVO from "../../contracts/NyatheesOVO.cdc"

pub fun main(address: Address, itemID: UInt64): &NyatheesOVO.NFT? {
  if let collection = getAccount(address).getCapability<&NyatheesOVO.Collection{NonFungibleToken.CollectionPublic, NyatheesOVO.NFTCollectionPublic}>(NyatheesOVO.CollectionPublicPath).borrow() {
    if let item = collection.borrowNFTItem(id: itemID) {
      return item
    }
  }

  return nil
}
