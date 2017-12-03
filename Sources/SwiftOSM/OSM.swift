//
//  OSM.swift
//  SwiftRoutingPackageDescription
//
//  Created by Ezekiel Elin on 12/3/17.
//

import Foundation
import SWXMLHash

public class OSM {
    public private(set) var nodes = Dictionary<String, OSMNode>()
    public private(set) var ways = Set<OSMWay>()
    
    public init(xml: XMLIndexer) throws {
        let xmlNodes = xml["osm"]["node"]
        for xmlNode in xmlNodes.all {
            let node = try OSMNode(xml: xmlNode, osm: self)
            self.nodes[node.id] = node
        }
        
        for xmlWay in xml["osm"]["way"].all {
            let way = try OSMWay(xml: xmlWay, osm: self)
            self.ways.insert(way)
        }
    }
}
