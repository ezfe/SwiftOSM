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

public enum EntranceTag: String {
    case main
    case yes
    case staircase
    case home
    case service
}

extension EntranceTag: Comparable {
    public static func <(lhs: EntranceTag, rhs: EntranceTag) -> Bool {
        switch lhs {
        case .service:
            return true
        case .home:
            return rhs != .service
        case .staircase:
            return rhs != .home && rhs != .service
        case .yes:
            return rhs != .home && rhs != .service && rhs != .staircase
        case .main:
            return false
        }
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
