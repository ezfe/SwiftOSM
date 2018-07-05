//
//  Set<OSMWay>+Pedestrian.swift
//  SWXMLHash
//
//  Created by Ezekiel Elin on 7/5/18.
//

import Foundation

extension Set where Element: OSMTaggable {
    func pedestrianFilter() -> Set<Element> {
        let allowedHighwayValues = ["pedestrian", "path", "footway", "steps"]
        
        return self.filter({ (way) -> Bool in
            if let highwayValue = way.tags["highway"], way.tags["building"] == nil && allowedHighwayValues.contains(highwayValue) {
                return true
            } else {
                return false
            }
        })
    }
}

extension Dictionary where Value: OSMTaggable {
    func pedestrianFilter() -> Dictionary<Key, Value> {
        let allowedHighwayValues = ["pedestrian", "path", "footway", "steps"]
        
        return self.filter({ (_, way) -> Bool in
            if let highwayValue = way.tags["highway"], way.tags["building"] == nil && allowedHighwayValues.contains(highwayValue) {
                return true
            } else {
                return false
            }
        })
    }
}

