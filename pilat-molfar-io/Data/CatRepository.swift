//
//  CatRepository.swift
//  pilat-molfar-io
//
//  Created by Eva Pilat on 19.11.2026.
//

import Foundation
import RealmSwift
import Realm

struct CatItem {
    let id: String
    let title: String
    let subtitle: String
    let photoURL: URL?
}

final class CatRepository {
    private let queue = DispatchQueue(label: "com.app.realm.read", qos: .userInitiated)
    
    func fetchCats(completion: @escaping ([CatItem]) -> Void) {
        queue.async {
            let start = CFAbsoluteTimeGetCurrent()
            
            let items: [CatItem] = autoreleasepool {
                let realm = try! Realm()
                realm.refresh()
                return realm.objects(Cat.self)
                // .sorted(byKeyPath: "name")
                    .map { cat in
                        CatItem(id: cat.id.stringValue,
                                title: "\(cat.name)",
                                subtitle: "\(cat.age) р. 🏠 \(cat.house.first?.name ?? "Вуличний")",
                                photoURL: CatPhotoService.imageURL(for: cat.photoId))
                    }
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
