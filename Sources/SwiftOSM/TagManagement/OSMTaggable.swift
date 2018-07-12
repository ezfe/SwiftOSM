//
//  OSMTaggable.swift
//  SwiftOSM
//
//  Created by Ezekiel Elin on 11/16/17.
//

import Foundation

public protocol OSMTaggable {
    var tags: Dictionary<String, String> { get }
}
