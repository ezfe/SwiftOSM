//
//  Dijkstra.swift
//  SwiftOSMPackageDescription
//
//  Created by Ezekiel Elin on 12/3/17.
//

import Foundation
import SwiftPriorityQueue

extension OSM {
    public func route(start: OSMNode, end: OSMNode) -> (distances: Dictionary<OSMNode, Double>, previous: Dictionary<OSMNode, OSMNode>) {
        
        print("Starting route between \(start) and \(end)")
        
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
//            print("Starting at \(node)")
            //Check if this node is reachable based on data
            if let distance = distances[node], distance < Double.infinity {
                //For every neighbor
                for neighbor in node.adjacent {
                    let distance = distance + node.location.distance(to: neighbor.location)
                    //If the new distance is less than the existing distance, update the distance and previous entry
//                    print("\t\(neighbor) is \(distance) away")
                    if (distances[neighbor] ?? Double.infinity) > distance {
                        distances[neighbor] = distance
                        previous[neighbor] = node
                        //Update the element
                        queue.reshuffle(element: neighbor)
                    }
                }
            }
            if node == end {
                break
            }
        }
        
        return (distances: distances, previous: previous)
    }
}
