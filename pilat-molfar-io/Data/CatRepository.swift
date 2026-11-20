//
//  CatRepository.swift
//  pilat-molfar-io
//
//  Created by Eva Pilat on 19.11.2026.
//

import Foundation
import CoreData

struct CatItem {
    let id: String
    let title: String
    let subtitle: String
    let photoURL: URL?
}

final class CatRepository {
    // private let queue = DispatchQueue(label: "com.app.realm.read", qos: .userInitiated)
    
    func fetchCats(completion: @escaping ([CatItem]) -> Void) {
        CoreDataStack.shared.container.performBackgroundTask { context in
            let start = CFAbsoluteTimeGetCurrent()
            
            let request = Cat.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            request.relationshipKeyPathsForPrefetching = ["house"]
            request.returnsObjectsAsFaults = false
            
            let cats = (try? context.fetch(request)) ?? []
            let items = cats.map { cat in
                CatItem(id: cat.id?.uuidString ?? UUID().uuidString,
                        title: "\(cat.name ?? "")",
                        subtitle: "\(cat.age) р. 🏠 \(cat.house?.name ?? "Вуличний")",
                        photoURL: CatPhotoService.imageURL(for: cat.photoId))
            }
            
            let time = CFAbsoluteTimeGetCurrent() - start
            print("fetched \(items.count) cats from DB in \(String(format: "%.2f", time))s | main thread: \(Thread.isMainThread)")
            
            DispatchQueue.main.async {
                print("delivered to ui, main thread: \(Thread.isMainThread)")
                completion(items)
            }
        }
    }
}
