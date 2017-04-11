//
//  MapRegion+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by SimranJot Singh on 10/04/17.
//  Copyright © 2017 SimranJot Singh. All rights reserved.
//

import Foundation
import CoreData


extension MapRegion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MapRegion> {
        return NSFetchRequest<MapRegion>(entityName: "MapRegion");
    }

    @NSManaged public var centerLatitude: Double
    @NSManaged public var centerLongitude: Double
    @NSManaged public var spanLatitude: Double
    @NSManaged public var spanLongitude: Double

}
