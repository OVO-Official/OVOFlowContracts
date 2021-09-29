// import MysteryBox from "../../contracts/MysteryBox.cdc"
// import NyatheesOVO from "../../contracts/NyatheesOVO.cdc"

import MysteryBox from 0xe07dd4765b2ede83
import NyatheesOVO from 0xe07dd4765b2ede83

transaction() {
	let admin: &{MysteryBox.MysteryBoxControlllerPrivate}
    let minter: Capability<&NyatheesOVO.NFTMinter>
	prepare(account: AuthAccount) {
		
        self.admin = account.borrow<&{MysteryBox.MysteryBoxControlllerPrivate}>(from: MysteryBox.MysteryBoxControlllerStoragePath) ?? panic("Could not borrow admin client")
        // self.minter = account.borrow<&{NyatheesOVO.CollectionPrivate}>(from: NyatheesOVO.CollectionStoragePath) ?? panic("Could not borrow minter client")
        self.minter = account.getCapability<&NyatheesOVO.NFTMinter>(NyatheesOVO.MinterPrivatePath)
        if(self.minter == nil){
            panic("Could not borrow minter client")
        }
        // self.minter.sayHello()
    }
	execute {
        self.admin.setMysteryBoxNFTPrividerCap(prividerCap: self.minter)
    }
}