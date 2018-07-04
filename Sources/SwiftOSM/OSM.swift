//
//  OSM.swift
//  SwiftRoutingPackageDescription
//
//  Created by Ezekiel Elin on 12/3/17.
//

import Foundation
import SWXMLHash

public class OSM {
    public let coveredArea: Rect
    public private(set) var nodes = Dictionary<Int, OSMNode>()
    public private(set) var ways = Dictionary<Int, OSMWay>()
    
    public init(xml: XMLIndexer, coveredArea: Rect) throws {
        self.coveredArea = coveredArea
        
        let xmlNodes = xml["osm"]["node"]
        for xmlNode in xmlNodes.all {
            let node = try OSMNode(xml: xmlNode, osm: self)
            self.nodes[node.id] = node
        }
        
        for xmlWay in xml["osm"]["way"].all {
            let way = try OSMWay(xml: xmlWay, osm: self)
            
//            let allowedHighwayValues = ["pedestrian", "path", "footway", "steps"]
//            if let highwayValue = way.tags["highway"], way.tags["building"] == nil && allowedHighwayValues.contains(highwayValue) {
//                self.ways[way.id] = way
//            }
            
            self.ways[way.id] = way
        }
        
        self.nodes = self.nodes.filter({ (id, node) -> Bool in
            return !node.ways.isEmpty
        })
    }
    
    public init() {
        self.coveredArea = Rect(Coordinate(latitude: 0, longitude: 0), Coordinate(latitude: 0, longitude: 0))
    }
    
    public func object(by id: OSMIdentifier) -> OSMIdentifiable? {
        switch id {
        case .node(let nodeId):
            return self.nodes[nodeId]
        case .way(let wayId):
            return self.ways[wayId]
        }
    }
    
    public func nodes(near startLocation: Coordinate, radius searchRadius: Int = 50) -> [OSMNode] {
        var found = Array<OSMNode>()
        
        for (_, node) in nodes {
            let distance = startLocation.distance(to: node.location)
            if distance < Double(searchRadius) {
                found.append(node)
            }
        }
        
        return found.sorted(by: { (lhs, rhs) -> Bool in
            return lhs.location.distance(to: startLocation) < rhs.location.distance(to: startLocation)
        })
    }
}
