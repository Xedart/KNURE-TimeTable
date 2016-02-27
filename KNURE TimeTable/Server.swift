//
//  Server.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 2/16/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import UIKit

class Server {
    
    static let apiRoot = "http://cist.nure.ua/ias/app/tt/"
    
    // methods:
    enum Method: String {
        case getGroups = "P_API_GROUP_JSON"
        case getTeachers = "PSOAPSAPSAPOSPOS"
        case getAuditoryes = "sasdasdasdasdad"
        case getSchedule = "/P_API_EVEN_JSON"
        case getAudytories = "sasdasdasd"
    }
    
    static func makeRequest(method: Method, parameters: [String]?, callback: (data: NSData?, responce: NSURLResponse?, error: NSError?) -> Void ) {
        // utr making:
        var urlStr = "\(apiRoot)\(method.rawValue)"
        if parameters != nil {
            for parameter in parameters! {
                urlStr.appendContentsOf(parameter)
            }
        }
        let URL = NSURL(string: urlStr)
        let request = NSMutableURLRequest(URL: URL!)
        let session = NSURLSession.sharedSession()
        
        // make request and callback
        let task = session.dataTaskWithRequest(request, completionHandler: callback)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            task.resume()
        })
    }
}





























