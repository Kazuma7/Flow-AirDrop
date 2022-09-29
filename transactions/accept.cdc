import AirDropCenter from 0x02
import NonFungibleToken from 0x01

transaction {

    prepare(account: AuthAccount){
        let seller = getAccount(0x03)

        if account.borrow<&AirDropCenter.Collection>(from: /storage/SampleCollection) == nil {

            let collection <- AirDropCenter.createEmptyCollection() as! @AirDropCenter.Collection
            account.save(<-collection, to: /storage/SampleCollection)
        }

        var tokenCollection: Capability<&NonFungibleToken.Collection> = account.getCapability<&NonFungibleToken.Collection>(/private/SampleCollection)
        if !tokenCollection.check() {
            account.link<&NonFungibleToken.Collection>(/private/SampleCollection, target: /storage/SampleCollection)!
        }
        
        //コレクションの受け皿のCapabilityを生成
        //let acceptCapability: Capability<&NonFungibleToken.Collection> = account.link<&NonFungibleToken.Collection>(/private/SampleCollection, target: /storage/SampleCollection)!
        let acceptCapability: Capability<&NonFungibleToken.Collection>  = account.getCapability<&NonFungibleToken.Collection>(/private/SampleCollection)

        let accepteRef = account.getCapability(/private/SampleCollection).borrow<&NonFungibleToken.Collection>()
                    ?? panic("Could not borrow a reference to the accepte's token collection")
        let tokenSaleCollection = seller.getCapability(/public/AirDropSwap)
                                    .borrow<&{AirDropCenter.Propose}>() ?? panic("Could not borrow from sale in storage")
        
        //tokenId:欲しいNFTのばんご
        let purchasedToken <- tokenSaleCollection.accept(tokenId: 13, acceptCapability: acceptCapability)
        accepteRef.deposit(token: <-purchasedToken)

        log("accept success")
    }
}