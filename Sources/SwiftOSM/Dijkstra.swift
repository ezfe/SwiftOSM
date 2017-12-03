//
//  Dijkstra.swift
//  SwiftOSMPackageDescription
//
//  Created by Ezekiel Elin on 12/3/17.
//

import Foundation
import SwiftPriorityQueue

extension OSM {
    func route(start: OSMNode, end: OSMNode) -> (distances: Dictionary<OSMNode, Double>, previous: Dictionary<OSMNode, OSMNode>) {
        
        var distances = Dictionary<OSMNode, Double>()
        var previous = Dictionary<OSMNode, OSMNode>()
        
        var queue = PriorityQueue<OSMNode>(order: { (lhs, rhs) -> Bool in
            return (distances[lhs] ?? Double.infinity) > (distances[rhs] ?? Double.infinity)
        })
        
        distances[start] = 0.0
        for (_, node) in self.nodes {
            queue.push(node)
        }
        
        //print(queue.pop() == keefe)
        
        while let node = queue.pop() {
            if let distance = distances[node], distance < Double.infinity {
                for neighbor in node.adjacent {
                    let distance = distance + node.location.distance(to: neighbor.location)
                    if (distances[neighbor] ?? Double.infinity) > distance {
                        distances[neighbor] = distance
                        previous[neighbor] = node
                        queue.reshuffle(element: neighbor)
                    }
                }
            }
        }
        
        return (distances: distances, previous: previous)
    }
}
