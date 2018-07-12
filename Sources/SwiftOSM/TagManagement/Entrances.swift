//
//  Entrances.swift
//  SwiftOSM
//
//  Created by Ezekiel Elin on 11/16/17.
//

import Foundation

public enum TagEntrance: String {
    case main
    case yes
    case staircase
    case home
    case service
}

extension TagEntrance: Comparable {
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
    
    public static func <(lhs: TagEntrance, rhs: TagEntrance) -> Bool {
        return lhs.routingPriority < rhs.routingPriority
    }
}

extension OSMNode {
    public var entrance: TagEntrance? {
        if let etv = self.tags["entrance"] {
            return TagEntrance(rawValue: etv)
        } else {
            return nil
        }
    }
}
