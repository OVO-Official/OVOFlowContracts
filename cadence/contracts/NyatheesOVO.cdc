import NonFungibleToken from 0xe80c67e389fccc73
//Test Net
// import NonFungibleToken from 0x0cd97d1704c9784d
// NFTItem
// NFT items for NFTItem!
//
pub contract NyatheesOVO: NonFungibleToken {

    // Events
    //
    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)
    pub event Minted(id: UInt64, metadata: {String:String})

    // Named Paths
    //
    pub let CollectionStoragePath: StoragePath
    pub let CollectionPublicPath: PublicPath
    pub let MinterStoragePath: StoragePath
    pub let CollectionPrivatePath: PrivatePath

    // totalSupply
    // The total number of NFTItem that have been minted
    //
    pub var totalSupply: UInt64

    // NFT
    // A NFT Item as an NFT
    //
    pub resource NFT: NonFungibleToken.INFT {
        // The token's ID
        pub let id: UInt64
        // The token's type, e.g. 3 == Hat
        pub let metadata: {String:String} 

        // initializer
        //
        init(initID: UInt64, metadata: {String:String}) {
            self.id = initID
            self.metadata = metadata
        }
    }

    // This is the interface that users can cast their NFTItem Collection as
    // to allow others to deposit NFTItem into their Collection. It also allows for reading
    // the details of NFTItem in the Collection.
    pub resource interface NFTCollectionPublic {
        pub fun deposit(token: @NonFungibleToken.NFT)
        pub fun getIDs(): [UInt64]
        pub fun idExists(id: UInt64): Bool
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT
        pub fun borrowNFTItem(id: UInt64): &NyatheesOVO.NFT? {
            // If the result isn't nil, the id of the returned reference
            // should be the same as the argument to the function
            post {
                (result == nil) || (result?.id == id):
                    "Cannot borrow NFTItem reference: The ID of the returned reference is incorrect"
            }
        }
    }

    // return the content for this NFT
    // only for mystery box
    pub resource interface CollectionPrivate {

        access(account) fun mintNFTForMysterBox(receiver: &{NonFungibleToken.CollectionPublic}, metadata: {String:String})

    }

    // Collection
    // A collection of NFTItem NFTs owned by an account
    //
    pub resource Collection: NFTCollectionPublic, CollectionPrivate, NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic {
        // dictionary of NFT conforming tokens
        // NFT is a resource type with an `UInt64` ID field
        //
        pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

        // withdraw
        // Removes an NFT from the collection and moves it to the caller
        //
        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
            let token <- self.ownedNFTs.remove(key: withdrawID) ?? panic("missing NFT")

            emit Withdraw(id: token.id, from: self.owner?.address)

            return <-token
        }

        pub fun idExists(id: UInt64): Bool {
            return self.ownedNFTs[id] != nil
        }

        // deposit
        // Takes a NFT and adds it to the collections dictionary
        // and adds the ID to the id array
        //
        pub fun deposit(token: @NonFungibleToken.NFT) {
            let token <- token as! @NyatheesOVO.NFT

            let id: UInt64 = token.id

            // add the new token to the dictionary which removes the old one
            let oldToken <- self.ownedNFTs[id] <- token

            emit Deposit(id: id, to: self.owner?.address)

            destroy oldToken
        }

        // getIDs
        // Returns an array of the IDs that are in the collection
        //
        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        // borrowNFT
        // Gets a reference to an NFT in the collection
        // so that the caller can read its metadata and call its methods
        //
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
            return &self.ownedNFTs[id] as &NonFungibleToken.NFT
        }

        // borrowNFTItem
        // Gets a reference to an NFT in the collection as a NFTItem,
        // exposing all of its fields (including the typeID).
        // This is safe as there are no functions that can be called on the NFTItem.
        //
        pub fun borrowNFTItem(id: UInt64): &NyatheesOVO.NFT? {
            if self.ownedNFTs[id] != nil {
                let ref = &self.ownedNFTs[id] as auth &NonFungibleToken.NFT
                return ref as! &NyatheesOVO.NFT
            } else {
                return nil
            }
        }

        access(account) fun mintNFTForMysterBox(receiver: &{NonFungibleToken.CollectionPublic},
                                                metadata: {String:String}){
            emit Minted(id: NyatheesOVO.totalSupply, metadata: metadata)

			// deposit it in the recipient's account using their reference
			receiver.deposit(token: <-create NyatheesOVO.NFT(initID: NyatheesOVO.totalSupply, metadata: metadata))

            NyatheesOVO.totalSupply = NyatheesOVO.totalSupply + (1 as UInt64)
        }

        // destructor
        destroy() {
            destroy self.ownedNFTs
        }

        // initializer
        //
        init () {
            self.ownedNFTs <- {}
        }
    }

    // createEmptyCollection
    // public function that anyone can call to create a new empty collection
    //
    pub fun createEmptyCollection(): @NonFungibleToken.Collection {
        return <- create Collection()
    }

    // NFTMinter
    // Resource that an admin or something similar would own to be
    // able to mint new NFTs
    //
	pub resource NFTMinter {

		// mintNFT
        // Mints a new NFT with a new ID
		// and deposit it in the recipients collection using their collection reference
        //
		pub fun mintNFT(recipient: &{NonFungibleToken.CollectionPublic}, metadata: {String:String}) {

			// deposit it in the recipient's account using their reference
			recipient.deposit(token: <-create NyatheesOVO.NFT(initID: NyatheesOVO.totalSupply, metadata: metadata))

            NyatheesOVO.totalSupply = NyatheesOVO.totalSupply + (1 as UInt64)

            emit Minted(id: NyatheesOVO.totalSupply, metadata: metadata)
		}
	}

    // fetch
    // Get a reference to a NFTItem from an account's Collection, if available.
    // If an account does not have a NFTItem.Collection, panic.
    // If it has a collection but does not contain the itemID, return nil.
    // If it has a collection and that collection contains the itemID, return a reference to that.
    //
    pub fun fetch(_ from: Address, itemID: UInt64): &NyatheesOVO.NFT? {
        let collection = getAccount(from)
            .getCapability(NyatheesOVO.CollectionPublicPath)!
            .borrow<&NyatheesOVO.Collection{NyatheesOVO.NFTCollectionPublic}>()
            ?? panic("Couldn't get collection")
        // We trust NFTItem.Collection.NFTItem to get the correct itemID
        // (it checks it before returning it).
        return collection.borrowNFTItem(id: itemID)
    }

    // initializer
    //
	init() {
        // Set our named paths
        self.CollectionStoragePath = /storage/NyatheesOVOCollection
        self.CollectionPublicPath = /public/NyatheesOVOCollection
        self.MinterStoragePath = /storage/NyatheesOVOMinter
        self.CollectionPrivatePath = /private/NyatheesOVOMintForBox

        // Initialize the total supply
        self.totalSupply = 0

        // Create a Minter resource and save it to storage
        let minter <- create NFTMinter()
        self.account.save(<-minter, to: self.MinterStoragePath)

        let collection <- create Collection()
        self.account.save(<-collection, to: self.CollectionStoragePath)
        self.account.link<&NyatheesOVO.Collection{NyatheesOVO.CollectionPrivate}>(self.CollectionPrivatePath, target: self.CollectionStoragePath)
        // create a public capability for the collection
        self.account.link<&NyatheesOVO.Collection{NonFungibleToken.CollectionPublic, NyatheesOVO.NFTCollectionPublic}>(NyatheesOVO.CollectionPublicPath, target: NyatheesOVO.CollectionStoragePath)
        emit ContractInitialized()
	}
}
