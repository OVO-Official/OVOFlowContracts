// import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
// import NyatheesOVO from "../../contracts/NyatheesOVO.cdc"

import NonFungibleToken from 0xe07dd4765b2ede83
import NyatheesOVO from 0xe07dd4765b2ede83

transaction(recipient: Address, withdrawID: UInt64) {
    prepare(signer: AuthAccount) {
        
        // get the recipients public account object
        let recipient = getAccount(recipient)

        // borrow a reference to the signer's NFT collection
        let collectionRef = signer.borrow<&NyatheesOVO.Collection>(from: NyatheesOVO.CollectionStoragePath)
            ?? panic("Could not borrow a reference to the owner's collection")

        // borrow a public reference to the receivers collection
        let depositRef = recipient.getCapability(NyatheesOVO.CollectionPublicPath)!.borrow<&{NonFungibleToken.CollectionPublic}>()!

        // withdraw the NFT from the owner's collection
        let nft <- collectionRef.withdraw(withdrawID: withdrawID)

        // Deposit the NFT in the recipient's collection
        depositRef.deposit(token: <-nft)
    }
}

