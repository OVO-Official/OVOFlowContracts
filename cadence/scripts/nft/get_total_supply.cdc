// import NyatheesOVO from "../../contracts/NyatheesOVO.cdc"
import NyatheesOVO from 0xe07dd4765b2ede83

// This scripts returns the number of KittyItems currently in existence.

pub fun main(): UInt64 {    
    return NyatheesOVO.totalSupply
}
