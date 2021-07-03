import Foundation

class MyJson {
    func convertListToJson(highScores: [Player]) -> String {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        let jsonData = try! jsonEncoder.encode(highScores)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)!
        
        return json
    }
    
    
    // Decode
    func convertJsonToList(json: String) -> [Player]? {
        let jsonDecoder = JSONDecoder()
        if json != "" {
            let highScores: [Player]
            let convertedData: Data = json.data(using: .utf8)!
            highScores = try! jsonDecoder.decode([Player].self,from: convertedData)
            return highScores
        }
        else{
            return [Player]()
        }
    }
}


class MyUserDefaults {
    private var myJson :MyJson = MyJson()
    private let userDefaultsKey:String = "Google API Key Here"
    
    //Store and retrive to/from UserDefults with json
    
    func storeUserDefaults(highScores: [Player]){
        UserDefaults.standard.set(myJson.convertListToJson(highScores: highScores),forKey: userDefaultsKey)
    }
    
    func retriveUserDefualts() -> [Player]{
        if let highScores: [Player] = myJson.convertJsonToList(json: UserDefaults.standard.string(forKey: userDefaultsKey) ?? ""){
                   return highScores
        }
        return [Player]()
    }
    func clearUserDefaults(){
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }
}
