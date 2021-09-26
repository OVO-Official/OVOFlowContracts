import NyatheesOVO from "../../contracts/NyatheesOVO.cdc"

pub fun main(addr: Address): [UInt64] {
	let account = getAccount(addr)
	let nftRef = account.getCapability(NyatheesOVO.CollectionPublicPath)
						.borrow<&{NyatheesOVO.NFTCollectionPublic}>()?? panic("Unable to borrow NyatheesOVO Receiver!")
	return nftRef.getIDs()
}