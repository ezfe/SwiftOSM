import Foundation
import Kanna

struct Coordinate {
    let latitude: Double
    let longitude: Double
}

class OpenStreetMaps {
    private let apiEntry = URL(string: "http://api.openstreetmap.org/api/0.6/")!
    
    func queryRect(min: Coordinate, max: Coordinate) -> Kanna.XMLDocument? {
        let requestURL = apiEntry.appendingPathComponent("/map?bbox=\(min.latitude),\(min.longitude),\(max.latitude),\(max.longitude)")
        
        let semaphore = DispatchSemaphore(value: 0)
        var data: Data? = nil
        
        let request = URLRequest(url: requestURL)
        let session = URLSession.shared.dataTask(with: request) { (responseData, _, _) in
            data = responseData
            semaphore.signal()
        }
        session.resume()
        semaphore.wait()
        
        if let data = data, let doc = Kanna.XML(xml: data, encoding: .utf8) {
            return doc
        } else {
            return nil
        }
    }
}
