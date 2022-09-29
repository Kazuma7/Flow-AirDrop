import AirDropCenter from "../contracts/AirDropCenter.cdc"

transaction {
    prepare(account: AuthAccount){
        let whiteUser1:Address = 0x01cf0e2f2f715450
        let whiteUser2:Address = 0x04
        let whiteUser3:Address = 0x05
        let permission:Bool = true
        let owner = account.borrow<&AirDropCenter.Owner>(from: /storage/Owner)
            ?? panic("You are not the owner.")
        
        owner.ownerSetWhiteList(whiteUser: whiteUser1,permission:permission)
        owner.ownerSetWhiteList(whiteUser: whiteUser2,permission:permission)
        owner.ownerSetWhiteList(whiteUser: whiteUser3,permission:permission)
        log("Successfully sent whitelist!")
    }
}