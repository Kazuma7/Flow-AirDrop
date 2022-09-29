import AirDropCenter from 0x02

transaction {
    prepare(account: AuthAccount){
        let test = account.borrow<&AirDropCenter.TokenPropose>(from: /storage/AirDropSwap)
            ?? panic("error")
        log(test.getWont(tokenId:13))
    }
}