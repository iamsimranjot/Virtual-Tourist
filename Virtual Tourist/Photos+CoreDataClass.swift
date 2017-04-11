//
//  Photos+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by SimranJot Singh on 10/04/17.
//  Copyright © 2017 SimranJot Singh. All rights reserved.
//

import Foundation
import CoreData

@objc(Photos)
public class Photos: NSManagedObject {
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(photoURL: String, pin: Pin, context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Photos", in: context)
        super.init(entity: entity!, insertInto: context)
        
        self.url = photoURL
        self.pin = pin
    }
}
