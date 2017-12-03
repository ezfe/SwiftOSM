import Foundation
import SWXMLHash

public struct Coordinate: CustomStringConvertible {
    public let latitude: Double
    public let longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public var description: String {
        return "{lat: \(latitude), lon: \(longitude)}"
    }

    private func radians(degrees: Double) -> Double {
        return degrees * Double.pi / 180.0
    }
    
    public func distance(to: Coordinate) -> Double {
        let earthRadius = 6_371_000.0 // meters
        
        let deltaLatitude = radians(degrees: to.latitude - self.latitude)
        let deltaLongitude = radians(degrees: to.longitude - self.longitude)
        
        let a: Double = pow(sin(deltaLatitude / 2), 2) + cos(radians(degrees: self.latitude)) * cos(radians(degrees: to.latitude)) * pow(sin(deltaLongitude / 2), 2)
        let c: Double = 2 * atan2(sqrt(a), sqrt(1 - a))
        
        return earthRadius * c
    }
}

public struct Rect {
    public let min: Coordinate
    public let max: Coordinate
    
    /**
     * Create a rect with two coordinates
     * automatically normalizes coordinates into a min and max
     */
    public init(_ a: Coordinate, _ b: Coordinate) {
        self.min = Coordinate(latitude: Swift.min(a.latitude, b.latitude),
                              longitude: Swift.min(a.longitude, b.longitude))
        self.max = Coordinate(latitude: Swift.max(a.latitude, b.latitude),
                              longitude: Swift.max(a.longitude, b.longitude))
    }
    
    private func mapURL() -> URL {
        return URL(string: "http://api.openstreetmap.org/api/0.6/map?bbox=\(min.longitude),\(min.latitude),\(max.longitude),\(max.latitude)")!
    }
    
    public func query() -> OSM? {
        let requestURL = mapURL()
        
        let semaphore = DispatchSemaphore(value: 0)
        var data: Data? = nil
        
        let request = URLRequest(url: requestURL)
        let session = URLSession.shared.dataTask(with: request) { (responseData, _, _) in
            if let responseData = responseData {
                data = responseData
            } else {
                print("A network error occurred")
            }
            semaphore.signal()
        }
        session.resume()
        semaphore.wait()
        
        if let data = data {
            do {
                return try OSM(xml: SWXMLHash.parse(data))
            } catch let err {
                print(err.localizedDescription)
                return nil
            }
        } else {
            return nil
        }
    }
}
