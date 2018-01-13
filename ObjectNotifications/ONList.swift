//
//  ONList.swift
//  ObjectNotifications
//
//  Created by Ben Winters on 1/13/18.
//  Copyright © 2018 Proper Apps LLC. All rights reserved.
//

import Foundation
import RealmSwift

class ONList: Object {
    
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var modifiedAt: Date = Date()
    
    @objc dynamic var name: String = ""
    @objc dynamic var sortOrder: Double = 1
    
    let items = LinkingObjects(fromType: ONItem.self, property: "list")
 
    override class func primaryKey() -> String? {
        return "id"
    }

    convenience init(name: String, sortOrder: Double) {
        self.init()
        self.name = name
        self.sortOrder = sortOrder
    }
    
}
