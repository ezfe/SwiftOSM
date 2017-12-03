//
//  OSMNode.swift
//  SwiftOSM
//
//  Created by Ezekiel Elin on 12/3/17.
//

import Foundation
import SWXMLHash

public class OSMNode: CustomStringConvertible, Equatable, Hashable, Comparable {
    private(set) weak var osm: OSM?
    
    // Fields
    public let id: String
    public let location: Coordinate
    public let tags: Set<OSMTag>
    
    public var ways: Set<OSMWay> {
        if let precomputed = self._ways {
            return precomputed
        } else {
            //            print("Calculating ways containing this node...")
            guard let osm = osm else {
                print("No reference to OSM object")
                return Set<OSMWay>()
            }
            var foundWays = Set<OSMWay>()
            
            for way in osm.ways {
                if way.nodes.contains(self) {
                    foundWays.insert(way)
                }
            }
            
            //            print("Found \(foundWays.count) ways")
            self._ways = foundWays
            return foundWays
        }
    }
    private var _ways: Set<OSMWay>? = nil
    
    public var adjacent: Set<OSMNode> {
        if let precomputed = self._adjacent {
            return precomputed
        } else {
            //            print("Calculating nodes adjacent to this node...")
            var foundNodes = Set<OSMNode>()
            
            for way in self.ways {
                guard let index = way.nodes.index(of: self) else {
                    print("\(self) should be in \(way) but isn't!")
                    continue
                }
                if index > 0 {
                    foundNodes.insert(way.nodes[index - 1])
                }
                if index < way.nodes.count - 1 {
                    foundNodes.insert(way.nodes[index + 1])
                }
            }
            
            //            print("Found \(foundNodes.count) adjacent nodes")
            self._adjacent = foundNodes
            return foundNodes
        }
    }
    private var _adjacent: Set<OSMNode>? = nil
    
    public init(xml: XMLIndexer, osm: OSM) throws {
        self.id = try xml.value(ofAttribute: "id")
        
        let lat: Double = try xml.value(ofAttribute: "lat")
        let lon: Double = try xml.value(ofAttribute: "lon")
        let coordinate = Coordinate(latitude: lat, longitude: lon)
        self.location = coordinate
        
        var tags = Set<OSMTag>()
        for xmlTag in xml["tag"].all {
            tags.insert(try OSMTag(xml: xmlTag))
        }
        self.tags = tags
        
        self.osm = osm
    }
    
    public var description: String {
        return "Node{id: \(self.id), location: \(self.location)}"
    }
    
    public static func ==(lhs: OSMNode, rhs: OSMNode) -> Bool {
        return lhs.id == rhs.id
    }
    
    public static func <(lhs: OSMNode, rhs: OSMNode) -> Bool {
        return lhs.id < rhs.id
    }
    
    public var hashValue: Int {
        return self.id.hashValue
    }
}
