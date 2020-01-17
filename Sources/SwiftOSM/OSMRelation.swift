//
//  File.swift
//  
//
//  Created by Ezekiel Elin on 8/27/19.
//

import Foundation
import SWXMLHash

public class OSMRelation: OSMIdentifiable, OSMTaggable {
    public let id: Int
    public lazy var identifier: OSMIdentifier = { OSMIdentifier.relation(self.id) }()

    public let tags: Dictionary<String, String>
    
    public let members: Array<Member>
    
    public init(id: Int, tags: Dictionary<String, String> = [:], members: [Member]) {
        self.id = id
        self.tags = tags
        self.members = members
    }
    
    internal init(xml: XMLIndexer, osm: OSM) throws {
        self.id = try xml.value(ofAttribute: "id")
        
        // Load <tag>s
        var tags = [String: String]()
        for xmlTag in xml["tag"].all {
            tags[try xmlTag.value(ofAttribute: "k")] = xmlTag.value(ofAttribute: "v")
        }
        self.tags = tags
            
        // Relation Members
        let xmlMemberRefs = xml["member"].all
        
        var members = Array<Member>()
        members.reserveCapacity(xmlMemberRefs.count)
        
        for memberRefTag in xmlMemberRefs {
            let type: String = try memberRefTag.value(ofAttribute: "type")
            let memberID: Int = try memberRefTag.value(ofAttribute: "ref")
            
            var role: String? = try memberRefTag.value(ofAttribute: "role")
            if let r = role, r.isEmpty {
                role = nil
            }
            
            let member = Member(type: type, id: memberID, role: role, osm: osm)
            members.append(member)
        }
        self.members = members
    }
}

public extension OSMRelation {
    class Member {
        private weak var osm: OSM?
        public let identifier: OSMIdentifier
        
        private var _entity: OSMIdentifiable?
        public var entity: OSMIdentifiable? {
            if let e = _entity {
                return e
            } else {
                let e = osm?.object(by: self.identifier)
                self._entity = e
                return e
            }
        }
        
        public let role: String?
        
        init(identifier: OSMIdentifier, role: String? = nil, osm: OSM) {
            self.identifier = identifier
            self.role = role
            self.osm = osm
        }
        
        init(type: String, id: Int, role: String? = nil, osm: OSM) {
            switch type {
            case "node":
                self.identifier = OSMIdentifier.node(id)
            case "way":
                self.identifier = OSMIdentifier.way(id)
            case "relation":
                self.identifier = OSMIdentifier.relation(id)
            default:
                fatalError("\(type) is not recognized")
            }
            
            self.role = role
            self.osm = osm
        }
    }
}
