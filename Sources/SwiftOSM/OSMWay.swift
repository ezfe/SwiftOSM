//
//  OSMWay.swift
//  SwiftOSM
//
//  Created by Ezekiel Elin on 12/3/17.
//

import Foundation
import SWXMLHash

public class OSMWay: OSMIdentifiable, OSMTaggable {
    public let id: Int
    public lazy var identifier: OSMIdentifier = { OSMIdentifier.way(self.id) }()
    
    public let tags: Dictionary<String, String>
    
    public let nodes: Array<OSMNode>
    
    public lazy var entrances: [OSMNode] = {
        return self.nodes
            .filter({ $0.entrance != nil })
            .sorted(by: { (lhs, rhs) -> Bool in
                if let lhse = lhs.entrance, let rhse = rhs.entrance {
                    return lhse > rhse
                } else {
                    return true
                }
            })
    }()
    
    public init(id: Int, tags: Dictionary<String, String> = [:], nodes: [OSMNode] = []) {
        self.id = id
        self.tags = tags
        self.nodes = nodes
    }
    
    internal init(xml: XMLIndexer, osm: OSM) throws {
        self.id = try xml.value(ofAttribute: "id")
        
        var tags = [String: String]()
        for xmlTag in xml["tag"].all {
            tags[try xmlTag.value(ofAttribute: "k")] = xmlTag.value(ofAttribute: "v")
        }
        self.tags = tags
        
        // Load <tag>s
        
        let xmlNodeRefs = xml["nd"].all
        
        var nodes = Array<OSMNode>()
        nodes.reserveCapacity(xmlNodeRefs.count)
        
        for nodeRefTag in xmlNodeRefs {
            let nodeID: Int = try nodeRefTag.value(ofAttribute: "ref")
            if let node = osm.nodes[nodeID] {
                nodes.append(node)
            } else {
                print("Unable to find node \(nodeID)")
            }
        }
        self.nodes = nodes
    }
}

extension OSMWay: Equatable {
    public static func ==(lhs: OSMWay, rhs: OSMWay) -> Bool {
        return lhs.id == rhs.id
    }
}

extension OSMWay: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension OSMWay: CustomStringConvertible {
    public var description: String {
        return "Way{id: \(id)}"
    }
}
