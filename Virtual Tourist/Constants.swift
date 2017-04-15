//
//  Constants.swift
//  Virtual Tourist
//
//  Created by SimranJot Singh on 12/04/17.
//  Copyright © 2017 SimranJot Singh. All rights reserved.
//

import CoreData

var context: NSManagedObjectContext = {
    
    return CoreDataManager.sharedInstance().context
}()

struct Constants {
    
    struct CoreDataStack {
        
        static let modelName = "Virtual_Tourist"
    }
}
