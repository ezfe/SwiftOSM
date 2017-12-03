//
//  OSMEntity.swift
//  routing-swiftPackageDescription
//
//  Created by Ezekiel Elin on 11/16/17.
//

import Foundation
import SWXMLHash

public struct OSMTag: Hashable, Equatable, CustomStringConvertible {
    public let name: String
    public let value: String
    
    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
    
    public init(xml: XMLIndexer) throws {
        self.init(name: try xml.value(ofAttribute: "k"), value: try xml.value(ofAttribute: "v"))
    }
    
    public var hashValue: Int {
        return (name + ":" + value).hashValue
    }
    
    public static func ==(lhs: OSMTag, rhs: OSMTag) -> Bool {
        return lhs.name == rhs.name && lhs.value == rhs.value
    }
    
    public var description: String {
        return "Tag{\(name): \(value)}"
    }
}
