import NyatheesOVO from "../../contracts/NyatheesOVO.cdc"

pub fun main(addr: Address): Int {
	let account = getAccount(addr)
	let nftRef = account.getCapability(NyatheesOVO.CollectionPublicPath)
						.borrow<&{NyatheesOVO.NFTCollectionPublic}>()?? panic("Unable to borrow NyatheesOVO Receiver!")
	var tempArray = nftRef.getIDs()
	return tempArray.length
}