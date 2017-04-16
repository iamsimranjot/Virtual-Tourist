//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by SimranJot Singh on 16/04/17.
//  Copyright © 2017 SimranJot Singh. All rights reserved.
//

import Foundation

class FlickrClient: APIHelper {
    
    
    //MARK: Singleton Class
    
    private static var sharedManager = FlickrClient()
    
    class func sharedInstance() -> FlickrClient {
        return sharedManager
    }
    
    
    //MARK: Init Method
    
    init() {
        let apiUrlData = APIURLData(scheme: Constants.FlickrClient.APIComponents.scheme,
                                    host: Constants.FlickrClient.APIComponents.host,
                                    path: Constants.FlickrClient.APIComponents.path)
        
        super.init(apiData: apiUrlData)
    }
    
    
    //MARK: Public Seacrh Method
    
    func getPhotosForLocation(latitude: Double, longitude: Double, page: Int = 1, handler: (_ photos: [[String : AnyObject]]?, _ pages: Int, _ error: String?) -> Void) {
        
        let URLParams = getParamsFor(latitude: latitude, longitude: longitude, page: page)
        
        let requestURL = urlForRequest(apiMethod: Constants.FlickrClient.APIMethod.search, parameters: URLParams)
        
        makeRequest(forURL: requestURL, requestMethod: .GET, setCompletionClosureWithSuccess: { (data, response) in
            
            
            
        }) { (errorString) in
            
            
            
        }
    }
}


//MARK: Helper Methods Extension

extension FlickrClient {
    
    fileprivate func getBoundingBoxFrom(latitude: Double, longitude: Double) -> String {
        
        let bottomLeftLon = max(longitude - Constants.FlickrClient.BoundingBox.BoundingBoxHalfWidth, Constants.FlickrClient.BoundingBox.MinimumLongitude)
        let bottomleftLat = max(latitude - Constants.FlickrClient.BoundingBox.BoundingBoxHalfHeight, Constants.FlickrClient.BoundingBox.MinimumLatitude)
        let topRightLon = min(longitude + Constants.FlickrClient.BoundingBox.BoundingBoxHalfHeight, Constants.FlickrClient.BoundingBox.MaximimLongitude)
        let topRightLat = min(latitude + Constants.FlickrClient.BoundingBox.BoundingBoxHalfHeight, Constants.FlickrClient.BoundingBox.MaximimLatitude)
        
        return "\(bottomLeftLon),\(bottomleftLat),\(topRightLon),\(topRightLat)"
    }
    
    fileprivate func getParamsFor(latitude: Double, longitude: Double, page: Int) -> [String : AnyObject] {
        
        let params = [Constants.FlickrClient.ParamKeys.APIKey: Constants.FlickrClient.ParamValues.APIKey,
                      Constants.FlickrClient.ParamKeys.BBox: getBoundingBoxFrom(latitude: latitude, longitude: longitude),
                      Constants.FlickrClient.ParamKeys.SafeSearch: Constants.FlickrClient.ParamValues.SafeSearch,
                      Constants.FlickrClient.ParamKeys.Extras: Constants.FlickrClient.ParamValues.Extras,
                      Constants.FlickrClient.ParamKeys.Format: Constants.FlickrClient.ParamValues.Format,
                      Constants.FlickrClient.ParamKeys.JsonCallBack: Constants.FlickrClient.ParamValues.JsonCallBack,
                      Constants.FlickrClient.ParamKeys.PerPage: Constants.FlickrClient.ParamValues.PerPage,
                      Constants.FlickrClient.ParamKeys.Page: String(page)]
        
        return params as [String : AnyObject]
    }
}

