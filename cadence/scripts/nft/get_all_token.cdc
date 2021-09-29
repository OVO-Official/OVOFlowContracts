// import NyatheesOVO from "../../contracts/NyatheesOVO.cdc"
import NyatheesOVO from 0xe07dd4765b2ede83

pub fun main(addr: Address): [UInt64] {
	let account = getAccount(addr)
	let nftRef = account.getCapability(NyatheesOVO.CollectionPublicPath)
						.borrow<&{NyatheesOVO.NFTCollectionPublic}>()?? panic("Unable to borrow NyatheesOVO Receiver!")
	return nftRef.getIDs()
}