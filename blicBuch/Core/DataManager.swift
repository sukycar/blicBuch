//
//  DataManager.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 5/9/20.
//  Copyright © 2020 sukydeveloper. All rights reserved.
//


import CoreData
import SwiftyJSON


final class DataManager {
    static let shared: DataManager = .init()
//    static let queue = DispatchQueue(label: "bg_core_data", qos: .background, attributes: .concurrent, autoreleaseFrequency: .never, target: nil)
    lazy private(set) var context: NSManagedObjectContext! = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    lazy private(set) var bgcontext: NSManagedObjectContext! = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
     
    
    func work(update:@escaping ((_ context:NSManagedObjectContext)-> Void)){
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.performBackgroundTask { (context) in
            update(context)
        }
    }
    
    func getDistinctValues(columnName:String, for entityName:String, and predicate:NSPredicate? = nil) -> [String]{
        let moc = self.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.resultType = .dictionaryResultType
        request.returnsDistinctResults = true
        request.predicate = predicate
        request.propertiesToFetch = [columnName]
        let results = try! moc?.fetch(request)
        if let res = results as? [[String: String]] {
            let distinctValues = res.compactMap { $0[columnName] }
            return distinctValues
        }
        return []
    }
}

extension NSManagedObject{
    static var entityName: String {
        return self.description()
    }
}

extension NSManagedObjectContext{

    
    
    func get<T>(predicate:NSPredicate?) -> T? where T : NSManagedObject{
        let request = T.self.fetchRequest()
        request.predicate = predicate
        var object:T?
        self.performAndWait {
            object = (try? self.fetch(request).first) as? T ?? nil
        }
        return object
    }
    
    func getList<T>(predicate:NSPredicate?, sort:[NSSortDescriptor]?) -> [T]? where T : NSManagedObject{
        let request = T.self.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sort
        var objects:[T]?
        self.performAndWait {
            objects = (try? self.fetch(request))  as? [T] ?? nil
        }
        return objects
    }
    
    func create<T>() -> T? where T : NSManagedObject{
        let entity = NSEntityDescription.entity(forEntityName: T.entityName, in: self)!
        var data:T?
        self.performAndWait {
            data = (NSManagedObject(entity: entity, insertInto: self) as? T) ?? nil

        }
        return data
    }
    
    func create<T>(object:(T?)->Void) -> T? where T : NSManagedObject{
        let entity = NSEntityDescription.entity(forEntityName: T.entityName, in: self)!
        var data:T?
        self.performAndWait {
            data = (NSManagedObject(entity: entity, insertInto: self) as? T) ?? nil
            object(data)
        }
        return data
    }
    func update<T>(predicate:NSPredicate?) -> T? where T : NSManagedObject{
        var itemToReturn:T?
        self.performAndWait {
            if let item:T = self.get(predicate: predicate){
                itemToReturn = item
            }else if let item:T = create(){
                itemToReturn = item
            }
        }
        return itemToReturn
    }
    func update<T>(predicate:NSPredicate?, object:(T?)->Void) -> T? where T : NSManagedObject{
        var itemToReturn:T?
        self.performAndWait {
            if let item:T = self.get(predicate: predicate){
                itemToReturn = item
            }else if let item:T = create(){
                itemToReturn = item
            }
            object(itemToReturn)
        }
        return itemToReturn
    }
    func updateDetails<T>(predicate:NSPredicate?, json: JSON) -> T? where T : NSManagedObject{
        var itemToReturn:T?
        self.performAndWait {
            if let item:T = self.get(predicate: predicate){
                itemToReturn = item
            }else if let item:T = create(){
                itemToReturn = item
            }
        }
        return itemToReturn
    }
    
    func delete<T>(fetchRequest: NSFetchRequest<T>, predicate:NSPredicate?) where T : NSManagedObject{
        self.performAndWait {
            if let objects:[T] = self.getList(predicate: predicate, sort: nil) {
                objects.forEach({ (object) in
                    self.delete(object)
                })
            }
        }
    }
}
