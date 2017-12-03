//
//  PriorityQueue+Reshuffle.swift
//  routing-swiftPackageDescription
//
//  Created by Ezekiel Elin on 11/17/17.
//

import Foundation
import SwiftPriorityQueue

extension PriorityQueue {
    public mutating func reshuffle(element: T) {
        self.remove(element)
        self.push(element)
    }
}
