//
//  ObjectIdentifier.swift
//  SwiftOSM
//
//  Created by Ezekiel Elin on 7/4/18.
//

import Foundation

public protocol OSMIdentifiable {
    var id: Int { get }
    var identifier: OSMIdentifier { get }
}

public enum OSMIdentifier {
    case way(Int)
    case node(Int)
}
