//
//  SubjectDataModel.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 9/29/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import Foundation

//{"id":1021252,"brief":"МодС","title":"Моделювання систем","hours":[ {"type":10,"val":18,"teachers":[ 412 ]} , {"type":0,"val":30,"teachers":[ 245 ]} ]}

public class Subject: NSObject, NSCoding {
    
    //Properties:
    public var briefTitle: String
    public var fullTitle: String
    
    //Initialization:
    public init(jsonData: JSON) {
        self.briefTitle = jsonData["brief"].stringValue
        self.fullTitle = jsonData["title"].stringValue
    }
    
    public override init() {
        self.briefTitle = String()
        self.fullTitle = String()
    }
    
    public convenience init(briefTitle: String, fullTitle: String) {
        self.init()
        self.briefTitle = briefTitle
        self.fullTitle = fullTitle
    }

    // NCCoding:
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        let briefTitle = aDecoder.decodeObject(forKey: Key.briefTitle) as! String
        let fullTitle = aDecoder.decodeObject(forKey: Key.fullTitle) as! String
        self.briefTitle = briefTitle
        self.fullTitle = fullTitle
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(briefTitle, forKey: Key.briefTitle)
        aCoder.encode(fullTitle, forKey: Key.fullTitle)
    }
    
    struct Key {
        static let briefTitle = "SBBriefTitle"
        static let fullTitle = "SBFullTitle"
    }
}
