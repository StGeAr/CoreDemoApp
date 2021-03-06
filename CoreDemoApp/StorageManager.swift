//
//  StorageManager.swift
//  CoreDemoApp
//
//  Created by Герман Ставицкий on 19.04.2022.
//

import Foundation
import CoreData

class StorageManager {
    static let shared = StorageManager()
        
    // MARK: - Core Data stack
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDemoApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext() {
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
    
    func fetchData() -> [Task] {
        let fetchRequest = Task.fetchRequest()
        let context = persistentContainer.viewContext
        guard let taskList = try? context.fetch(fetchRequest) else { return [] }
        return taskList
    }
    
    func save(_ taskName: String) {
        var taskList = fetchData()
        let context = persistentContainer.viewContext
        let task = Task(context: context)
        task.title = taskName
        taskList.append(task)
        saveContext()
    }
        
    func delete(_ task: Task) {
        let context = persistentContainer.viewContext
        context.delete(task)
        saveContext()
    }
    
    func update() {

    }
    
    private init() {}
}
