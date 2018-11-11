//
//  OSMTaggable.swift
//  SwiftOSM
//
//  Created by Ezekiel Elin on 11/16/17.
//

import Foundation

public protocol OSMTaggable {
    /// Tags assigned to this entity
    var tags: Dictionary<String, String> { get }
}
