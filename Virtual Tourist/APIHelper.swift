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
    
    
    //MARK: Data Request
    
    func makeRequest(forURL Url: URL, requestMethod: HTTPMethod, requestHeaders: [String:String]? = nil, requestBody: [String:AnyObject]? = nil,
                                                                        setCompletionClosureWithSuccess success: @escaping (_ data: NSData?, _ response: URLResponse?) -> Void,
                                                                        faliure: @escaping (_ errorString: String) -> Void) {
        
        // Create request from passed URL
        var request = URLRequest(url: Url)
        request.httpMethod = requestMethod.rawValue
        
        // Add headers if present
        if let requestHeaders = requestHeaders {
            for (key, value) in requestHeaders {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Add body if present
        if let requestBody = requestBody {
            request.httpBody = try! JSONSerialization.data(withJSONObject: requestBody, options: JSONSerialization.WritingOptions())
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                print("Error in response")
                faliure(Constants.Errors.ConnectionError)
                return
            }
            
            guard let status = (response as? HTTPURLResponse)?.statusCode, status >= 200 && status <= 299 else {
                print("Wrong response status code")
                faliure(Constants.Errors.UsernamePasswordIncorrect)
                return
            }
            
            guard let _ = data else {
                print("Wrong response data")
                faliure(Constants.Errors.ConnectionError)
                return
            }
            
            success(data as NSData?, response)
        }
        
        task.resume()
    }
}


//MARK: Request Helper

extension APIHelper {
    
    func urlForRequest(apiMethod: String? = nil, pathExtension: String? = nil, parameters: [String : AnyObject]? = nil) -> URL {
        
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
