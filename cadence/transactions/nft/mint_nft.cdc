// import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
// import NyatheesOVO from "../../contracts/NyatheesOVO.cdc"

import NonFungibleToken from 0xe07dd4765b2ede83
import NyatheesOVO from 0xe07dd4765b2ede83


// This transction uses the NFTMinter resource to mint a new NFT.
//
// It must be run with the account that has the minter resource
// stored at path /storage/NFTMinter.

transaction(recipient: Address, matedata: {String:String}) {
    
    // local variable for storing the minter reference
    let minter: &NyatheesOVO.NFTMinter

    prepare(signer: AuthAccount) {

        // borrow a reference to the NFTMinter resource in storage
        self.minter = signer.borrow<&NyatheesOVO.NFTMinter>(from: NyatheesOVO.MinterStoragePath)
            ?? panic("Could not borrow a reference to the NFT minter")
    }

    execute {
        // get the public account object for the recipient
        let recipient = getAccount(recipient)

        // borrow the recipient's public NFT collection reference
        let receiver = recipient
            .getCapability(NyatheesOVO.CollectionPublicPath)!
            .borrow<&{NonFungibleToken.CollectionPublic}>()
            ?? panic("Could not get receiver reference to the NFT Collection")

        // mint the NFT and deposit it to the recipient's collection
        self.minter.mintNFT(recipient: receiver, metadata: matedata)
    }
}
