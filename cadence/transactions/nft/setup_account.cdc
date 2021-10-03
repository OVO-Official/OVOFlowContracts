import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import NyatheesOVO from "../../contracts/NyatheesOVO.cdc"

// This transaction configures an account to hold Kitty Items.

transaction {
    prepare(signer: AuthAccount) {
        // if the account doesn't already have a collection
        if signer.borrow<&NyatheesOVO.Collection>(from: NyatheesOVO.CollectionStoragePath) == nil {

            // create a new empty collection
            let collection <- NyatheesOVO.createEmptyCollection()
            
            // save it to the account
            signer.save(<-collection, to: NyatheesOVO.CollectionStoragePath)

            // create a public capability for the collection
            signer.link<&NyatheesOVO.Collection{NonFungibleToken.CollectionPublic, NyatheesOVO.NFTCollectionPublic}>(NyatheesOVO.CollectionPublicPath, target: NyatheesOVO.CollectionStoragePath)
        }
    }
}
