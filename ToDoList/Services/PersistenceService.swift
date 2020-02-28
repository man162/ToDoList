//
//  PersistenceService.swift
//  ToDoList
//
//  Created by Manpreet Singh on 2020-02-28.
//  Copyright © 2020 Manpreet Singh. All rights reserved.
//

import Foundation
import CoreData

class PersistenceService {

    private init(){}

    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Core Data stack

    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    static func saveContext () {
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
