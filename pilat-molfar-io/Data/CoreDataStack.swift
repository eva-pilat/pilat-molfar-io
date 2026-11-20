//
//  CoreDataStack.swift
//  pilat-molfar-io
//
//  Created by Eva Pilat on 20.11.2026.
//

import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "CatsModel")
        container.loadPersistentStores { _, error in
            if let error { fatalError("Core Data load error: \(error)") }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.undoManager = nil
        return context
    }
}
