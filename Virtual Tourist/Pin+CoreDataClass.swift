//
//  Pin+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by SimranJot Singh on 10/04/17.
//  Copyright © 2017 SimranJot Singh. All rights reserved.
//

import Foundation
import CoreData
import MapKit

@objc(Pin)
public class Pin: NSManagedObject, MKAnnotation {
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(latitude: Double, longitude: Double, context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entity(forEntityName: "Pin", in: context)
        super.init(entity: entity!, insertInto: context)
        
        self.latitude = latitude
        self.longitude = longitude
        self.flickrConfig = FlickrConfigs(context: context)
    }
    
    public var coordinate: CLLocationCoordinate2D {
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    func deletePhotos(context: NSManagedObjectContext, handler: (_ error: String?) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Photos")
        request.predicate = NSPredicate(format: "pin == %@", self)
        
        do {
            let photos = try context.fetch(request) as! [Photos]
            for photo in photos {
                context.delete(photo)
            }
        } catch { }
        
        handler(nil)
    }
}
