

import Foundation

class Location: Codable {
    var longitude : Double = 0
    var latitude : Double = 0

    init (){}
    
    init (latitude: Double, longitude: Double)
    {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public var toString: String {
        return "latitude: \(self.latitude), longitude: \(self.longitude)"
    }
}
