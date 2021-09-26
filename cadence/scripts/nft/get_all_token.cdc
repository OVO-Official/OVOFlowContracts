import NyatheesOVO from 0xe80c67e389fccc73

pub fun main(addr: Address): [UInt64] {
	let account = getAccount(addr)
	let nftRef = account.getCapability(NyatheesOVO.CollectionPublicPath)
						.borrow<&{NyatheesOVO.NFTCollectionPublic}>()?? panic("Unable to borrow NyatheesOVO Receiver!")
	return nftRef.getIDs()
}