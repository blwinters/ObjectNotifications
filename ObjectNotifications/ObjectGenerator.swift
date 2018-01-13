//
//  ObjectGenerator.swift
//  ObjectNotifications
//
//  Created by Ben Winters on 1/13/18.
//  Copyright © 2018 Proper Apps LLC. All rights reserved.
//

import Foundation
import RealmSwift

class ObjectGenerator {
    
    let realm = try! Realm()
    
    let lists: [Int] = Array(1...10)
    let items: [Int] = Array(1...100)
    
    func createObjectsIfNeeded(completion: @escaping () -> Void) {
        let realm = try! Realm()
        
        let lists = realm.objects(ONList.self)
        guard lists.count == 0 else {
            completion()
            print("Realm already has \(lists.count) lists")
            return
        }
        
        DispatchQueue(label: "createObjects").async {
            autoreleasepool {
                
                let bgRealm = try! Realm()
                
                for list in self.lists {
                    bgRealm.beginWrite()
                    
                    let newList = ONList(name: "\(list)", sortOrder: Double(list))
                    bgRealm.add(newList)
                    
                    let newItems = self.items.map({ ONItem(name: "\($0)", sortOrder: Double($0), list: newList) })
                    bgRealm.add(newItems)
                    
                    try! bgRealm.commitWrite()
                }
                
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
}
