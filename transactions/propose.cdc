import AirDropCenter from 0x02
import NonFungibleToken from 0x01

transaction {
    prepare(account: AuthAccount){
        if account.borrow<&AirDropCenter.TokenPropose>(from: /storage/AirDropSwap) == nil {
            //let ownerCapability = account.getCapability<&{FungibleToken.Receiver}>(/public/flowTokenReceiver)

            //SampleCollectionのCapabilityを作成してる
            var tokenCollection: Capability<&NonFungibleToken.Collection> = account.getCapability<&NonFungibleToken.Collection>(/private/SampleCollection)
            if !tokenCollection.check() {
              tokenCollection = account.link<&NonFungibleToken.Collection>(/private/SampleCollection, target: /storage/SampleCollection)!
            }

            //SawpのCapabilityを作成
            let collection <- AirDropCenter.createTokenPropose(proposeCapability: tokenCollection)
            account.save(<-collection, to: /storage/AirDropSwap)
            account.link<&AirDropCenter.TokenPropose{AirDropCenter.Propose}>(/public/AirDropSwap, target: /storage/AirDropSwap)
        }

        //Swapをborrowする
        let tokenSaleCollection = account.borrow<&AirDropCenter.TokenPropose>(from: /storage/AirDropSwap)
            ?? panic("Could not borrow from sale in storage")

        //tokenId:自分の持ってるNFTの番号
        tokenSaleCollection.listForPropose(tokenId: 13, wont: 12)
        log(tokenSaleCollection.getWont(tokenId: 13))

        log("propose success!!")
    }
}