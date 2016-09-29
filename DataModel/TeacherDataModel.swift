//
//  TeacherDataModel.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 9/29/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import Foundation


//{"id":5335711,"full_name":"Дейнеко Анастасія Олександрівна","short_name":"Дейнеко А. О."}

public class Teacher: NSObject, NSCoding {
    
    //Properties:
    public var full_name: String
    public var short_name: String
    
    //Initialization:
    public init(jsonData: JSON) {
        self.full_name = jsonData["full_name"].stringValue
        self.short_name = jsonData["short_name"].stringValue
    }
    
    public override init() {
        self.full_name = String()
        self.short_name = String()
    }
    
    public convenience init(full_name: String, short_name: String) {
        self.init()
        self.full_name = full_name
        self.short_name = short_name
    }
    
    // NCCoding:
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        let full_name = aDecoder.decodeObject(forKey: Key.fullName) as! String
        let short_name = aDecoder.decodeObject(forKey: Key.shortName) as! String
        self.full_name = full_name
        self.short_name = short_name
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(full_name, forKey: Key.fullName)
        aCoder.encode(short_name, forKey: Key.shortName)
    }
    struct Key {
        static let fullName = "TCfullName"
        static let shortName = "TCshortName"
    }
}
