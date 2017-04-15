//
//  APIHelper.swift
//  Virtual Tourist
//
//  Created by SimranJot Singh on 15/04/17.
//  Copyright © 2017 SimranJot Singh. All rights reserved.
//

import Foundation


//MARK: HTTP Request Method Enum

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}


//MARK: APIUrlData

struct APIURLData {
    let scheme: String
    let host: String
    let path: String
}

class APIHelper {
    
    //MARK: Proprties
    
    fileprivate let session: URLSession
    fileprivate let URLData: APIURLData
    
    
    //MARK: Initializer
    
    init(apiData: APIURLData) {
        
        session = URLSession.shared
        URLData = apiData
    }
    
}


//MARK: Request Helper

extension APIHelper {
    
    func urlForRequest(apiMethod: String?, pathExtension: String? = nil, parameters: [String : AnyObject]? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = URLData.scheme
        components.host = URLData.host
        components.path = URLData.path + (apiMethod ?? "") + (pathExtension ?? "")
        
        if let parameters = parameters {
            
            components.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems?.append(queryItem)
            }
        }
        
        return components.url!
    }
}
