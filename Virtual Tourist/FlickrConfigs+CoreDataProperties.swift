//
//  FlickrConfigs+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by SimranJot Singh on 10/04/17.
//  Copyright © 2017 SimranJot Singh. All rights reserved.
//

import Foundation
import CoreData


extension FlickrConfigs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlickrConfigs> {
        return NSFetchRequest<FlickrConfigs>(entityName: "FlickrConfigs");
    }

    @NSManaged public var nextPage: Int32
    @NSManaged public var totalPages: Int32
    @NSManaged public var pin: Pin?

}
