//
//  OSMNode.swift
//  SwiftOSM
//
//  Created by Ezekiel Elin on 12/3/17.
//

import Foundation
import SWXMLHash

public class OSMNode: OSMIdentifiable, OSMTaggable {
    public unowned let osm: OSM
    
    public let id: Int
    public lazy var identifier: OSMIdentifier = { OSMIdentifier.node(self.id) }()
    public let location: Coordinate
    public let tags: Dictionary<String, String>
    
    public lazy var ways: Set<OSMWay> = {
        var foundWays = Set<OSMWay>()
        
        for (_, way) in osm.ways {
            if way.nodes.contains(self) {
                foundWays.insert(way)
            }
        }
        
        return foundWays
    }()
    
    public lazy var pedestrianWays: Set<OSMWay> = {
       return self.ways.pedestrianFilter()
    }()
    
    public lazy var adjacent: Set<OSMNode> = {
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

        return foundNodes
    }()
    
    public lazy var pedestrianAdjacent: Set<OSMNode> = {
        //TODO: This is very similar to above definition
        //Probably should DRY this out :p
        var foundNodes = Set<OSMNode>()
        
        for way in self.pedestrianWays { //Only change?
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
        
        return foundNodes
    }()
    
    public init(xml: XMLIndexer, osm: OSM) throws {
        self.id = try xml.value(ofAttribute: "id")
        
        let lat: Double = try xml.value(ofAttribute: "lat")
        let lon: Double = try xml.value(ofAttribute: "lon")
        let coordinate = Coordinate(latitude: lat, longitude: lon)
        self.location = coordinate
        
        var tags = [String: String]()
        for xmlTag in xml["tag"].all {
            tags[try xmlTag.value(ofAttribute: "k")] = xmlTag.value(ofAttribute: "v")
        }
        self.tags = tags
        
        self.osm = osm
    }
}

extension OSMNode: CustomStringConvertible {
    public var description: String {
        return "Node{id: \(self.id), location: \(self.location)}"
    }
}

extension OSMNode: Equatable {
    public static func ==(lhs: OSMNode, rhs: OSMNode) -> Bool {
        return lhs.id == rhs.id
    }
}
    
extension OSMNode: Comparable {
    public static func <(lhs: OSMNode, rhs: OSMNode) -> Bool {
        return lhs.id < rhs.id
    }
}
 
extension OSMNode: Hashable {
    public var hashValue: Int {
        return self.id.hashValue
    }
}
