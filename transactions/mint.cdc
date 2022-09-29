import AirDropCenter from "../contracts/AirDropCenter.cdc"

transaction {

  prepare(account: AuthAccount) {
    if account.borrow<&AirDropCenter.Collection>(from: /storage/SampleCollection) == nil {
        let collection <- AirDropCenter.createEmptyCollection() as! @AirDropCenter.Collection
        account.save(<-collection, to: /storage/SampleCollection)
    }
    
    let sample <- AirDropCenter.mintToken(address:account.address)
    let user = account.borrow<&AirDropCenter.Collection>(from: /storage/SampleCollection)!
    user.deposit(token: <- sample)
  }

  execute {
  log("Successfully received the airdrop.")
  }
}