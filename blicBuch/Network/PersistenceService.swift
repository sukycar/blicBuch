//
//  PersistenceService.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 5/10/20.
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import Foundation
import CoreData

class PersistenceService {
    
    private init() {
    
    }
    static let shared = PersistenceService()
    
    var context: NSManagedObjectContext{ return persistentContainer.viewContext}
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "blicBuch")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

   
    // MARK: - Core Data Saving support
    func save () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
               
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
