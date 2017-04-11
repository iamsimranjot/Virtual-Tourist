//
//  FlickrConfigs+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by SimranJot Singh on 10/04/17.
//  Copyright © 2017 SimranJot Singh. All rights reserved.
//

import Foundation
import CoreData

@objc(FlickrConfigs)
public class FlickrConfigs: NSManagedObject {
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(nextPage: Int32, totalPages: Int32, pin: Pin, context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entity(forEntityName: "FlickrConfigs", in: context)
        super.init(entity: entity!, insertInto: context)
        
        self.nextPage = nextPage
        self.totalPages = totalPages
        self.pin = pin
    }
}
