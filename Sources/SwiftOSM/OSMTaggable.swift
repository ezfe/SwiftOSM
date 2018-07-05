//
//  OSMEntity.swift
//  routing-swiftPackageDescription
//
//  Created by Ezekiel Elin on 11/16/17.
//

import Foundation
import SWXMLHash

public protocol OSMTaggable {
    var tags: Dictionary<String, String> { get }
}

//MARK: Entrance Tags

public enum EntranceTag: String {
    case main
    case yes
    case staircase
    case home
    case service
}

extension EntranceTag: Comparable {
    private var routingPriority: Int {
        switch self {
        case .service:
            return 0
        case .home:
            return 1
        case .staircase:
            return 2
        case .yes:
            return 3
        case .main:
            return 4
        }
    }
    
    public static func <(lhs: EntranceTag, rhs: EntranceTag) -> Bool {
        return lhs.routingPriority < rhs.routingPriority
    }
}

extension OSMTaggable {
    public var entrance: EntranceTag? {
        if let etv = self.tags["entrance"] {
            return EntranceTag(rawValue: etv)
        } else {
            return nil
        }
    }
}
