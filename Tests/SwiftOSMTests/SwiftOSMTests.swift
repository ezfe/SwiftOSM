import XCTest
@testable import SwiftOSM
import SWXMLHash

class SwiftOSMTests: XCTestCase {
    
    lazy var xmlData: XMLIndexer = {
        let data = try! Data(contentsOf: URL(string: "https://f001.backblazeb2.com/b2api/v1/b2_download_file_by_id?fileId=4_za1ea9c3fff6bfd94633d0b1e_f115aac9a06ddecc8_d20181110_m215634_c001_v0001105_t0051")!)
        return SWXMLHash.parse(data)
    }()
    lazy var osm: OSM = {
        return try! OSM(xml: self.xmlData)
    }()
    
    func testInitializer() {
        let osm = try? OSM(xml: self.xmlData)
        XCTAssertNotNil(osm)
    }
    
    func testHasWays() {
        XCTAssert(osm.ways.count > 693)
        XCTAssert(osm.nodes.count > 0)
    }
    
    func testQueryAcopian() {
        guard let acopian = osm.object(by: .way(204187226)) else {
            print(osm.ways)
            XCTFail("Acopian does not exist")
            return
        }
        
        print(acopian)
        if let acopian = acopian as? OSMWay {
            acopian.entrances.forEach { (node) in
                print(node.tags)
            }
        }
    }
    
    func testMotorwayNavigatable() {
        let osm = OSM()
        let way = OSMWay(id: -1, tags: [ "highway": "motorway" ], nodes: [], osm: osm)
        
        XCTAssertTrue(way.access(for: .motor_vehicle))
        XCTAssertFalse(way.access(for: .foot))
    }

    func testFootwayNavigatable() {
        let osm = OSM()
        let way = OSMWay(id: -1, tags: [ "highway": "footway" ], nodes: [], osm: osm)
        
        XCTAssertFalse(way.access(for: .motor_vehicle))
        XCTAssertTrue(way.access(for: .foot))
    }
    
    func testMotorwayFootYesNavigatable() {
        let osm = OSM()
        let way = OSMWay(id: -1, tags: [ "highway": "motorway", "foot": "yes" ], nodes: [], osm: osm)
        
        XCTAssertTrue(way.access(for: .motor_vehicle))
        XCTAssertTrue(way.access(for: .foot))
    }
    
    func testRoutingPerformance() {
        guard let acopian = osm.object(by: .way(204187226)) as? OSMWay else {
            XCTFail("Unable to find Acopian")
            return
        }
        
        guard let keefe = osm.object(by: .way(480957420)) as? OSMWay else {
            XCTFail("Unable to find Acopian")
            return
        }
        
        guard let farinon = osm.object(by: .way(204187233)) as? OSMWay else {
            XCTFail("Unable to find Acopian")
            return
        }

        self.measure { [weak self] in
            osm.route(start: acopian.entrances, end: keefe.entrances)
            osm.route(start: farinon.entrances, end: keefe.entrances)
            osm.route(start: farinon.entrances, end: acopian.entrances)
        }
    }
    
    static var allTests = [
        ("testInitializer", testInitializer),
        ("testHasWays", testHasWays),
        ("testQueryAcopian", testQueryAcopian),
        ("testMotorwayNavigatable", testMotorwayNavigatable),
        ("testRoutingPerformance", testRoutingPerformance)
    ]
}
