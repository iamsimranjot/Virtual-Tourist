//
//  Photos+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by SimranJot Singh on 11/04/17.
//  Copyright © 2017 SimranJot Singh. All rights reserved.
//

import Foundation
import CoreData


extension Photos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photos> {
        return NSFetchRequest<Photos>(entityName: "Photos");
    }

    @NSManaged public var url: String?
    @NSManaged public var pin: Pin?

}
