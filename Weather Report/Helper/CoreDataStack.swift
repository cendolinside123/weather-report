//
//  CoreDataStack.swift
//  Weather Report
//
//  Created by Jan Sebastian on 29/03/22.
//

import Foundation
import CoreData

class CoreDataStack {
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            print("storeDescription: \(storeDescription)")
            if let getError = error as NSError? {
                print("Unresolved error \(getError), \(getError.userInfo)")
            }
        })
        
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    lazy var privateManagedContext: NSManagedObjectContext = {
        return self.storeContainer.newBackgroundContext()
    }()
    
    func saveContext() {
        guard managedContext.hasChanges else {
            return
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
        
    }
    
    func doInBackground( managedContext: @escaping (NSManagedObjectContext) -> Void) {
        self.storeContainer.performBackgroundTask({ context in
            managedContext(context)
        })
    }
    
    
    func getStoreContainer() -> NSPersistentContainer {
        return storeContainer
    }
    
    func setStroreContainer(container: NSPersistentContainer) {
        storeContainer = container
    }
}
