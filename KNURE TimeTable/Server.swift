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
    
    // methods:
    enum Method: String {
        case getGroups = "P_API_GROUP_JSON"
        case getTeachers = "/P_API_PODR_JSON"
        case getSchedule = "/P_API_EVEN_JSON"
        case getAudytories = "P_API_AUDITORIES_JSON"
        case addRecepient = "http://nuretimetable-xedart.rhcloud.com/addRecepient"
        case removeRecepient = "http://nuretimetable-xedart.rhcloud.com/removeRecepient"
    }
    
    static func makeRequest(_ method: Method, parameters: [String]?, postBody: String?, callback: @escaping (_ data: Data?, _ responce: URLResponse?, _ error: Error?) -> Void ) {
        
        // url making:
        var urlStr = String()
        if method == .addRecepient || method == .removeRecepient {
            urlStr = method.rawValue
        } else {
            urlStr = "\(apiRoot)\(method.rawValue)"
        }
        
        if parameters != nil {
            for parameter in parameters! {
                urlStr.append(parameter)
            }
        }
        
        let URL = Foundation.URL(string: urlStr)
        var request = URLRequest(url: URL!)
        
        if postBody != nil {
            let encodedPostbody = postBody?.data(using: String.Encoding.utf8)
            request.httpMethod = "POST"
            request.httpBody = encodedPostbody
        }
        
        
        let session = URLSession.shared
        
        // make request and callback
        let task = session.dataTask(with: request, completionHandler: callback)
        DispatchQueue.main.async(execute: { () -> Void in
            task.resume()
        })
    }
}






























