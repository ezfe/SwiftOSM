//
//  ObjectIdentifier.swift
//  SwiftOSM
//
//  Created by Ezekiel Elin on 7/4/18.
//

import Foundation

public protocol OSMIdentifiable {
    /// The OSM-assigned ID of the way
    ///
    /// OpenStreetMap IDs are unique only within object types.
    /// Way and node IDs can conflict
    var id: Int { get }
    
    var identifier: OSMIdentifier { get }
}

public enum OSMIdentifier {
    case way(Int)
    case node(Int)
    case relation(Int)

    public static func build(type: String?, id: Int?) -> OSMIdentifier? {
        guard let type = type, let id = id else {
            return nil
        }

        switch type {
            case "way":
                return .way(id)
            case "node":
                return .node(id)
            case "relation":
                return .relation(id)
            default:
                return nil
        }
    }
}

extension OSMIdentifier: Codable {
    enum CodingKeys: CodingKey {
        case type
        case id
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let type = try container.decode(String.self, forKey: .type)
        let id = try container.decode(Int.self, forKey: .id)
        switch type {
        case "node":
            self = .node(id)
        case "way":
            self = .way(id)
        default:
            fatalError("\(type) isn't accounted for")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .node(let id):
            try container.encode("node", forKey: .type)
            try container.encode(id, forKey: .id)
        case .way(let id):
            try container.encode("way", forKey: .type)
            try container.encode(id, forKey: .id)
        case .relation(let id):
            try container.encode("relation", forKey: .type)
            try container.encode(id, forKey: .id)
        }
    }
}
