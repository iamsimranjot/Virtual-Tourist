//
//  MapRegion+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by SimranJot Singh on 10/04/17.
//  Copyright © 2017 SimranJot Singh. All rights reserved.
//

import Foundation
import CoreData

@objc(MapRegion)
public class MapRegion: NSManagedObject {
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(centerLatitude: Double, centerLongitude: Double, spanLatitude: Double, spanLongitude: Double, context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entity(forEntityName: "MapRegion", in: context)
        super.init(entity: entity!, insertInto: context)
    }

}
