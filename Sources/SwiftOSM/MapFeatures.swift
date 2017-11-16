//
//  MapFeatures.swift
//  routing-swiftPackageDescription
//
//  Created by Ezekiel Elin on 11/16/17.
//

import Foundation
import SWXMLHash

public class OSM {
    private(set) var nodes = Set<OSMNode>()
    
    public init(xml: XMLIndexer) throws {
        let xmlNodes = xml["osm"]["node"]
        for node in xmlNodes.all {
            nodes.insert(try OSMNode(xml: node))
        }
    }
}

public class OSMNode: CustomStringConvertible, Equatable, Hashable {
    public let id: String
    public let location: Coordinate
    
    public init(xml: XMLIndexer) throws {
        self.id = try xml.value(ofAttribute: "id")
        
        let lat: Double = try xml.value(ofAttribute: "lat")
        let lon: Double = try xml.value(ofAttribute: "lon")
        let coordinate = Coordinate(latitude: lat, longitude: lon)
        self.location = coordinate
    }
    
    public var description: String {
        return "Node{id: \(self.id), location: \(self.location)}"
    }
    
    public static func ==(lhs: OSMNode, rhs: OSMNode) -> Bool {
        return lhs.id == rhs.id
    }
    
    public var hashValue: Int {
        return self.id.hashValue
    }
}
