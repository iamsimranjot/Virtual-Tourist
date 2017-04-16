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
    
    var isFetching = false
    
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
    
    //MARK: Get Photos for Loction
    
    func getPhotosForLocation(context: NSManagedObjectContext, handler:@escaping (_ errorString: String?) ->  Void) {
        
        if isFetching {
            handler(Constants.Errors.FetchingOnGoing)
            return
        }
        
        isFetching = true;
        
        FlickrClient.sharedInstance().getPhotosForLocation(latitude: pin!.latitude, longitude: pin!.longitude, page: Int(nextPage), success: { (photosArray, totalPages) in
            
            self.isFetching = false
            
            for photo in photosArray! where photo[Constants.FlickrClient.ParamValues.Extras] != nil {
                
                _ = Photos(photoURL: photo[Constants.FlickrClient.ParamValues.Extras] as! String, pin: self.pin!, context: context)
            }
            
            self.totalPages = Int32(min(15, totalPages))
            self.nextPage = self.totalPages >= self.nextPage + 1 ? self.nextPage + 1 : 1
            
            handler(nil)
            
        }) { (errorString) in
            
            handler(errorString)
        }
    }
}
