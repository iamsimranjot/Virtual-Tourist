//
//  MapRegion+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by SimranJot Singh on 10/04/17.
//  Copyright © 2017 SimranJot Singh. All rights reserved.
//

import MapKit
import CoreData

@objc(MapRegion)
public class MapRegion: NSManagedObject {
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(region: MKCoordinateRegion, context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entity(forEntityName: "MapRegion", in: context)
        super.init(entity: entity!, insertInto: context)
        
        self.region = region
    }
    
    var region: MKCoordinateRegion {
        
        set {
            
            centerLatitude = newValue.center.latitude
            centerLongitude = newValue.center.longitude
            spanLatitude = newValue.span.latitudeDelta
            spanLongitude = newValue.span.longitudeDelta
        }
        get {
            
            let center = CLLocationCoordinate2DMake(centerLatitude, centerLongitude)
            let span = MKCoordinateSpanMake(spanLatitude, spanLongitude)
            return MKCoordinateRegionMake(center, span)
        }
    }
}
