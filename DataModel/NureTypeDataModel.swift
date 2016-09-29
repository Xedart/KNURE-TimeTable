//
//  NureTypeDataModel.swift
//  KNURE TimeTable
//
//  Created by Shkil Artur on 9/29/16.
//  Copyright © 2016 Shkil Artur. All rights reserved.
//

import Foundation

// {"id":0,"short_name":"Лк","full_name":"Лекція", "id_base":0, "type":"lecture"}

public class NureType: NSObject, NSCoding {
    
    //Properties:
    public var id: String
    public var short_name: String
    public var full_name: String
    
    public init(jsonData: JSON) {
        self.id = jsonData["id"].stringValue
        self.short_name = jsonData["short_name"].stringValue
        self.full_name = jsonData["full_name"].stringValue
    }
    
    public override init() {
        self.id = String()
        self.short_name = String()
        self.full_name = String()
    }
    
    public convenience init(short_name: String, full_name: String, id: String) {
        self.init()
        self.id = id
        self.short_name = short_name
        self.full_name = full_name
    }
    
    
    // NCCoding:
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        let short_name = aDecoder.decodeObject(forKey: Key.short_name) as! String
        let full_name = aDecoder.decodeObject(forKey: Key.full_name) as! String
        let id = aDecoder.decodeObject(forKey: Key.id_key) as! String
        
        self.id = id
        self.short_name = short_name
        self.full_name = full_name
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(short_name, forKey: Key.short_name)
        aCoder.encode(full_name, forKey: Key.full_name)
        aCoder.encode(id, forKey: Key.id_key)
    }
    
    struct Key {
        static let short_name = "TPShortName"
        static let full_name = "TPFullName"
        static let id_key = "TPId"
    }
}
