import XCTest
@testable import SwiftOSM
import SWXMLHash

class SwiftOSMTests: XCTestCase {
    
    var xmlData: XMLIndexer!
    var rect: Rect!
    var osm: OSM!
    
    override func setUp() {
        let min = Coordinate(latitude: 40.700886107, longitude: -75.2042269707)
        let max = Coordinate(latitude: 40.6936141011, longitude: -75.2157282829)
        self.rect = Rect(min, max)

        let data = try! Data(contentsOf: self.rect.mapURL)
        self.xmlData = SWXMLHash.parse(data)
        
        self.osm = try! OSM(xml: self.xmlData, coveredArea: self.rect)
    }
    
    func testInitializer() {
        let osm = try? OSM(xml: self.xmlData, coveredArea: self.rect)
        XCTAssertNotNil(osm)
    }
    
    func testHasWays() {
        XCTAssertEqual(osm.ways.count, 690)
        XCTAssert(osm.nodes.count > 0)
    }
    
    func testQueryAcopian() {
        let osm = try! OSM(xml: self.xmlData, coveredArea: self.rect)
        guard let acopian = osm.object(by: .way(204187226)) else {
            print(osm.ways)
            XCTFail("Acopian does not exist")
            return
        }
        
        print(acopian)
    }

    static var allTests = [
        ("testInitializer", testInitializer),
        ("testHasWays", testHasWays),
        ("testQueryAcopian", testQueryAcopian)
    ]
}
