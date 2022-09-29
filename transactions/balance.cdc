import AirDropCenter from "../contracts/AirDropCenter.cdc"

transaction {
    prepare(account: AuthAccount){
        if account.borrow<&AirDropCenter.Collection>(from: /storage/SampleCollection) == nil {
            let collection <- AirDropCenter.createEmptyCollection() as! @AirDropCenter.Collection
            account.save(<-collection, to: /storage/SampleCollection)
        }
        
        let confirm = account.borrow<&AirDropCenter.Collection>(from: /storage/SampleCollection)
            ?? panic("error")

        if confirm.ownedNFTs.length != 0 {
            log("token exsist")
            log(confirm.ownedNFTs.keys)
        } else {
            log("non token exsist")
        }
    }
}