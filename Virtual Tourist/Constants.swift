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

var sharedDataManager: CoreDataManager = {
    
    return CoreDataManager.sharedInstance()
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
            static let path = "/services/rest"
        }
        
        
        //MARK: API Params Keys
        
        struct ParamKeys {
            
            static let Method = "method"
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
            
            static let Method = "flickr.photos.search"
            static let APIKey = "b5254ef41767c0f0dea73afa7cf6fc36"
            static let SafeSearch = "1"
            static let Extras = "url_m"
            static let Format = "json"
            static let JsonCallBack = "1"
            static let PerPage = "20"
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
    
    
    //MARK: MapViewController Constants
    
    struct MapVC {
        
        static let PinReuseIdentifier = "PinIdentifier"
        static let ActionSheetTitle = "Remove Location?"
        static let ActionYes = "Yes!"
        static let ActionCancel = "Cancel"
    }
    
    
    //MARK: CollectionViewController Constants
    
    struct CollectionVC {
        
        static let StoryboardIdentifier = "CollectionVC"
        static let CollectionViewCellIdentifier = "PhotoCollectionViewCell"
    }
    
    
    //MARK: Error Constants
    
    struct Errors {
        
        static let ConnectionError = "Connection Error"
        static let UsernamePasswordIncorrect = "Username or password is incorrect"
        static let FetchingOnGoing = "Fetching in Progress"
        static let ResponseInorrect = "Incorrrect Response"
    }
}
