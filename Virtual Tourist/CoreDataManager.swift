//
//  CoreDataManager.swift
//  Virtual Tourist
//
//  Created by SimranJot Singh on 15/04/17.
//  Copyright © 2017 SimranJot Singh. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    
    //MARK: Singleton Class
    
    private static var sharedManager = CoreDataManager()
    
    class func sharedInstance() -> CoreDataManager {
        return sharedManager
    }
    
    
    // MARK: - CoreDataStack
    
    lazy private var model: NSManagedObjectModel = {
        
        let modelURL = Bundle.main.url(forResource: Constants.CoreDataStack.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    
    lazy fileprivate var dbURL: URL = {
        
        let fm = FileManager.default
        let docUrl = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbURL = docUrl.appendingPathComponent("\(Constants.CoreDataStack.modelName)" + ".sqlite")
        
        return dbURL
    }()
    
    
    lazy fileprivate var coordinator: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        
        let options = [NSInferMappingModelAutomaticallyOption: true,NSMigratePersistentStoresAutomaticallyOption: true]
        
        do {
            
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.dbURL, options: options as [NSObject : AnyObject]?)
            
        } catch {
            
            print("unable to add store at \(self.dbURL)")
            abort()
        }
        
        return coordinator
    }()
    
    
    lazy fileprivate var persistingContext: NSManagedObjectContext = {
        
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.coordinator
        
        return context
    }()
    
    
    lazy var context: NSManagedObjectContext = {
        
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = self.persistingContext
        
        return context
    }()
    
    
    lazy fileprivate var backgroundContext: NSManagedObjectContext = {
        
        // Create a background context child of main context
        
        let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.parent = self.context
        
        return backgroundContext
    }()
    
    
    // MARK: Utils
    
    fileprivate func addStoreCoordinator(_ storeType: String, configuration: String?, storeURL: URL, options : [NSObject:AnyObject]?) throws {
        
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: dbURL, options: nil)
    }
}


// MARK: - CoreDataStack (Removing Data)

internal extension CoreDataManager  {
    
    func dropAllData() throws {
        
        // delete all the objects in the db. This won't delete the files, it will
        // just leave empty tables.
        
        try coordinator.destroyPersistentStore(at: dbURL, ofType:NSSQLiteStoreType , options: nil)
        try addStoreCoordinator(NSSQLiteStoreType, configuration: nil, storeURL: dbURL, options: nil)
    }
}


// MARK: - CoreDataStack (Batch Processing in the Background)

extension CoreDataManager {
    
    typealias Batch = (_ workerContext: NSManagedObjectContext) -> ()
    
    func performBackgroundBatchOperation(_ batch: @escaping Batch) {
        
        backgroundContext.perform() {
            
            batch(self.backgroundContext)
            
            // Save it to the parent context, so normal saving
            // can work
            do {
                try self.backgroundContext.save()
            } catch {
                fatalError("Error while saving backgroundContext: \(error)")
            }
        }
    }
}


// MARK: - CoreDataStack (Save Data)

extension CoreDataManager {
    
    func save() {
        
        context.performAndWait() {
            
            if self.context.hasChanges {
                do {
                    
                    try self.context.save()
                    
                } catch {
                    
                    fatalError("Error while saving main context: \(error)")
                }
                
                // now we save in the background
                
                self.persistingContext.perform() {
                    do {
                        
                        try self.persistingContext.save()
                        
                    } catch {
                        
                        fatalError("Error while saving persisting context: \(error)")
                    }
                }
            }
        }
    }
}
