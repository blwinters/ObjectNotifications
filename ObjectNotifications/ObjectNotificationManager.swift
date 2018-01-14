//
//  ObjectNotificationManager.swift
//  ObjectNotifications
//
//  Created by Ben Winters on 1/13/18.
//  Copyright © 2018 Proper Apps LLC. All rights reserved.
//

import Foundation
import RealmSwift

class ObjectNotificationManager {
    
    let realm = try! Realm()
    
    var collectionNotificationTokens: [NotificationToken] = []
    var objectNotificationTokens: [String: NotificationToken] = [:]
    
    deinit {
        for token in objectNotificationTokens.values {
            token.invalidate()
        }
        for token in collectionNotificationTokens {
            token.invalidate()
        }
    }
    
    private func realmObjectClass(name: String) -> Object.Type {
        
        if let objClass = NSClassFromString(name) {
            return objClass as! Object.Type
        } else {
            let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
            return NSClassFromString("\(namespace).\(name)") as! Object.Type
        }
    }
    
    func setup() {
        let start = Date()
        
        for schema in realm.schema.objectSchema {
            
            let objectClass = realmObjectClass(name: schema.className)
            let primaryKey = objectClass.primaryKey()!
            let results = realm.objects(objectClass)
            
            // Register for collection notifications
            let token = results.observe({ (collectionChange) in //[weak self]
                
                switch collectionChange {
                case .update(_, _, let insertions, _):
                    
                    for index in insertions {
                        
                        let object = results[index]
                        let name = object.value(forKey: "name") as! String
                        print("Updated \(schema.className): \(name)")
                    }
                default: break
                }
            })
            collectionNotificationTokens.append(token)
            
            // Register for object updates
            for object in results {
                
                let identifier = object.value(forKey: primaryKey) as! String
                let token = object.observe({ (change) in //[weak self]
                    
                    switch change {
                    case .change(let properties):
                        print("Changed object with id: \(identifier), properties: \(properties)")
                        
                    case .deleted:
                        print("Deleted object with id: \(identifier)")
                        
                    default:
                        break
                    }
                })
                
                objectNotificationTokens[identifier] = token
            }
        }
        
        let end = Date()
        
        let duration = end.timeIntervalSince(start)
        print("Created tokens in \(duration) seconds")
    }
    
}
