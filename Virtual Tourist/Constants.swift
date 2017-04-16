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
    
    
    //MARK: CoreData Constants
    
    struct CoreDataStack {
        
        static let modelName = "Virtual_Tourist"
    }
    
    
    //MARK: Flickr Client Constants
    
    struct FlickrClient {

        
        //MARK: API Components
        
        struct APIComponents {
            
            static let scheme = "https"
            static let host = "api.flickr.com"
            static let path = "services/rest/"
        }
        
        
        //MARK: API Method
        
        struct APIMethod {
            
            static let search = "flickr.photos.search"
        }
        
        
        //MARK: API Params Keys
        
        struct ParamKeys {
            
            static let APIKey = "api_key"
            static let BBox = "bbox"
            static let SafeSearch = "safe_search"
            static let Extras = "extras"
            static let Format = "format"
            static let JsonCallBack = "nojsoncallback"
            static let PerPage = "per_page"
            static let Page = "page"
        }
        
        
        //MARK: API Params Values
        
        struct ParamValues {
            
            static let APIKey = "b5254ef41767c0f0dea73afa7cf6fc36"
            static let SafeSearch = "1"
            static let Extras = "url_m"
            static let Format = "json"
            static let JsonCallBack = "1"
            static let PerPage = "30"
        }
        
        
        //MARK: Bounding Box Constants
        
        struct BoundingBox {
            
            static let BoundingBoxHalfWidth = 1.0
            static let BoundingBoxHalfHeight = 1.0
            static let MinimumLatitude = -90.0
            static let MaximimLatitude = 90.0
            static let MinimumLongitude = -180.0
            static let MaximimLongitude = 180.0
        }
    }
}
