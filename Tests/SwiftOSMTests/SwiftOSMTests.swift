import XCTest
@testable import SwiftOSM
import SWXMLHash

class SwiftOSMTests: XCTestCase {
    
    var xmlData: XMLIndexer!
    var rect: Rect!
    
    override func setUp() {
        let min = Coordinate(latitude: 40.700886107, longitude: -75.2042269707)
        let max = Coordinate(latitude: 40.6936141011, longitude: -75.2157282829)
        self.rect = Rect(min, max)

        let data = try! Data(contentsOf: self.rect.mapURL)
        self.xmlData = SWXMLHash.parse(data)
    }
    
    func testHasWays() {
        let osm = try! OSM(xml: self.xmlData, coveredArea: self.rect)
        XCTAssert(osm.ways.count > 0)
        XCTAssert(osm.nodes.count > 0)
    }

    static var allTests = [
        ("testHasWays", testHasWays),
    ]
}
