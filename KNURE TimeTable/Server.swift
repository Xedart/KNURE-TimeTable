//
//  Server.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/16/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

// class server handles http request to the api server ( cist )

class Server {
    
    static var apiRoot = "http://cist.nure.ua/ias/app/tt/"
   // static let testApiRoot =
    
    // methods:
    enum Method: String {
        case getGroups = "P_API_GROUP_JSON"
        case getTeachers = "/P_API_PODR_JSON"
        case getSchedule = "/P_API_EVEN_JSON"
        case getAudytories = "P_API_AUDITORIES_JSON"
    }
    
    static func makeRequest(_ method: Method, parameters: [String]?, callback: (data: Data?, responce: URLResponse?, error: Error?) -> Void ) {
        
        // This code is for test only: {
        if method == .getSchedule {
            apiRoot = "http://xedartbackend-xedart.rhcloud.com"
        } else {
            apiRoot = "http://cist.nure.ua/ias/app/tt/"
        }
        // }
        
        // url making:
        var urlStr = "\(apiRoot)\(method.rawValue)"
        
        // TODO: Uncomment after beck to production mode:
        /*
        if parameters != nil {
            for parameter in parameters! {
                urlStr.append(parameter)
            }
        } */
        
        let URL = Foundation.URL(string: urlStr)
        let request = URLRequest(url: URL!)
        let session = URLSession.shared
        
        // make request and callback
        let task = session.dataTask(with: request, completionHandler: callback)
        DispatchQueue.main.async(execute: { () -> Void in
            task.resume()
        })
    }
}






























