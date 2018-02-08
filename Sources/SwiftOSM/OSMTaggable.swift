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
