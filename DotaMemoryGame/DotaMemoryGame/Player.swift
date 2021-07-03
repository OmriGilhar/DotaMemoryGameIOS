import Foundation
class Player : Codable{
    var name:String = ""
    var location:Location = Location()
    var score: Int = 0
    var date: String = ""
    
    init() {}

    init(score:Int, playerName:String, gameLocation:Location){
        let formatterDate = DateFormatter()
        formatterDate.dateStyle = .long
        formatterDate.timeStyle = .short
        formatterDate.locale = .current
        self.date = formatterDate.string(from: Date())
        self.score = score
        self.name = playerName
        self.location = gameLocation
    }
}
