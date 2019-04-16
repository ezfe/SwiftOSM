//
//  PedestrianAccess.swift
//  SwiftOSM
//
//  Created by Ezekiel Elin on 7/11/18.
//

import Foundation

/**
 * Open Street Map `highway=*` tag
 *
 * [Open Street Map Wiki Entry](https://wiki.openstreetmap.org/wiki/Key:highway)
 */
public enum TagHighway: String {
    /// A restricted access major divided highway, normally with 2 or more running lanes plus emergency hard shoulder
    case motorway
    /// The most important roads in a country's system that aren't motorways.
    case trunk
    /// The next most important roads in a country's system. (Often link larger towns.)
    case primary
    /// The next most important roads in a country's system. (Often link towns.)
    case secondary
    /// The next most important roads in a country's system. (Often link smaller towns and villages)
    case tertiary
    /// The least most important through roads in a country's system – i.e. minor roads of a lower classification than tertiary, but which serve a purpose other than access to properties. Often link villages and hamlets.
    ///
    /// - Warning: The word 'unclassified' is a historical artefact of the UK road system and does not mean that the classification is unknown; you can use `.road` for that
    case unclassified
    /// Roads which serve as an access to housing, without function of connecting settlements. Often lined with housing.
    case residential
    /// For access roads to, or within an industrial estate, camp site, business park, car park etc. Can be used in conjunction with service=* to indicate the type of usage and with access=* to indicate who can use it and in what circumstances.
    case service
    
    /// The link roads (sliproads/ramps) leading to/from a `.motorway` from/to a `.motorway` or lower class highway. Normally with the same motorway restrictions.
    case motorway_link
    /// The link roads (sliproads/ramps) leading to/from a `.trunk` road from/to a trunk road or lower class highway.
    case trunk_link
    /// The link roads (sliproads/ramps) leading to/from a `.primary` road from/to a primary road or lower class highway.
    case primary_link
    /// The link roads (sliproads/ramps) leading to/from a `.secondary` road from/to a secondary road or lower class highway.
    case secondary_link
    /// The link roads (sliproads/ramps) leading to/from a `.tertiary` road from/to a tertiary road or lower class highway.
    case tertiary_link
    
    /// For [living streets](http://en.wikipedia.org/wiki/living_street), which are residential streets where pedestrians have legal priority over cars, speeds are kept very low and where children are allowed to play on the street.
    case living_street
    /// For roads used mainly/exclusively for pedestrians in shopping and some residential areas which may allow access by motorised vehicles only for very limited periods of the day.
    case pedestrian
    /// Roads for mostly agricultural or forestry uses.
    ///
    /// To describe the quality of a track, see tracktype=*.
    ///
    /// - Note: Although tracks are often rough with unpaved surfaces, this tag is not describing the quality of a road but its use. Consequently, if you want to tag a general use road, use one of the general highway values instead of track.
    case track
    /// A busway where the vehicle guided by the way (though not a railway) and is not suitable for other traffic.
    ///
    /// - Warning: This is not a normal bus lane, use access=no, psv=yes instead!
    case bus_guideway
    /// For runaway truck ramps, runaway truck lanes, emergency escape ramps, or truck arrester beds. It enables vehicles with braking failure to safely stop.
    case escape
    /// A course or track for (motor) racing
    case raceway
    /// A road/way/street/motorway/etc. of unknown type. It can stand for anything ranging from a footpath to a motorway.
    ///
    /// - Warning: This tag should only be used temporarily until the road/way/etc. has been properly surveyed. If you do know the road type, do not use this value, instead use one of the more specific highway=* values.
    case road
    
    /// For designated footpaths; i.e., mainly/exclusively for pedestrians. This includes walking tracks and gravel paths.
    ///
    /// - Note: If bicycles are allowed as well, you can indicate this by adding a bicycle=yes tag.
    ///
    /// - Warning: Should not be used for paths where the primary or intended usage is unknown.
    ///     - Use highway=pedestrian for pedestrianised roads in shopping or residential areas
    ///     - Use highway=track if it is usable by agricultural or similar vehicles.
    case footway
    /// For horses.
    ///
    /// Equivalent to highway=path + horse=designated.
    case bridleway
    /// For flights of steps (stairs) on footways.
    ///
    /// Use with `step_count=*` to indicate the number of steps
    case steps
    /// A non-specific path.
    ///
    /// - Note: Use other cases in most circumstances:
    ///     - `highway=footway` for paths mainly for walkers
    ///     - `highway=cycleway` for one also usable by cyclists
    ///     - `highway=bridleway` for ones available to horses as well as walkers
    ///     - `highway=track` for ones which is passable by agriculture or similar vehicles.
    case path
    
    /// For designated cycleways. Add foot=* only if default-access-restrictions do not apply.
    case cycleway
    
    /// For planned roads.
    ///
    /// Use `proposed=*` and a value of the proposed highway value.
    case proposed
    
    /// For roads under construction.
    ///
    /// Use `construction=*` to hold the value for the completed road.
    case construction
}

public enum AccessType: String {
    case motor_vehicle
    case horse
    case bicycle
    case foot
}

public enum AccessLevel: String {
    case yes
    case no
    case permissive
    case `private`
    case destination
    case designated
}

public extension OSMTaggable {
    var highway: TagHighway? {
        if let htv = self.tags["highway"] {
            return TagHighway(rawValue: htv)
        } else {
            return nil
        }
    }
    
    func access(for accessType: AccessType) -> Bool {
        guard let highwayTag = self.highway else {
            return false
        }
        
        if let accessTagValue = self.tags[accessType.rawValue],
            [
                AccessLevel.yes.rawValue,
                AccessLevel.designated.rawValue,
                AccessLevel.permissive.rawValue
            ].contains(accessTagValue) {
            
            return true
        }
        
        switch highwayTag {
        case .motorway, .motorway_link:
            return accessType == .motor_vehicle
        case .trunk, .trunk_link,
             .primary, .primary_link,
             .secondary, .secondary_link,
             .tertiary, .tertiary_link,
             .unclassified,
             .residential,
             .service,
             .road:
            
            switch accessType {
            case .motor_vehicle, .horse, .bicycle:
                return true
            default:
                return false
            }
        case .living_street:
            return true
        case .pedestrian:
            switch accessType {
            case .bicycle, .foot:
                return true
            default:
                return false
            }
        case .path:
            switch accessType {
            case .horse, .bicycle, .foot:
                return true
            default:
                return false
            }
        case .bridleway:
            switch accessType {
            case .horse, .bicycle, .foot:
                return true
            default:
                return false
            }
        case .cycleway:
            switch accessType {
            case .bicycle, .foot:
                return true
            default:
                return false
            }
        case .footway, .steps:
            switch accessType {
            case .foot:
                return true
            default:
                return false
            }
        case .track, .raceway, .bus_guideway, .escape:
            return false
        case .proposed, .construction:
            return false
        }
    }
}

extension Set where Element: OSMTaggable {
    func filter(for accessType: AccessType) -> Set<Element> {
        return self.filter({ (element) -> Bool in
            return element.access(for: accessType)
        })
    }
}

extension Dictionary where Value: OSMTaggable {
    func filter(for accessType: AccessType) -> Dictionary<Key, Value> {
        return self.filter({ (_, element) -> Bool in
            return element.access(for: accessType)
        })
    }
}
