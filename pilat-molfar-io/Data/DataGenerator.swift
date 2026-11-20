//
//  DataGenerator.swift
//  pilat-molfar-io
//
//  Created by Eva Pilat on 19.11.2026.
//

import Foundation
import CoreData

enum DataGenerator {
    static func generate(count: Int = 100_000,
                         housesCount: Int = 500,
                         batchSize: Int = 10_000,
                         photoIds: [String],
                         completion: @escaping (TimeInterval) -> Void) {
        let context = CoreDataStack.shared.newBackgroundContext()
        
        context.perform {
            let start = CFAbsoluteTimeGetCurrent()
            
            var houses: [CatHouse] = []
            for _ in 0..<housesCount {
                let house = CatHouse(context: context)
                house.id = UUID()
                house.name = "\(houseNames.randomElement()!) №\(Int.random(in: 1...999))"
                houses.append(house)
            }
            try! context.save()
            let houseIDs = houses.map(\.objectID)
            context.reset()
            
            var created = 0
            while created < count {
                let n = min(batchSize, count - created)
                autoreleasepool {
                    let batchHouses = houseIDs.map { context.object(with: $0) as! CatHouse }
                    for _ in 0..<n {
                        let cat = Cat(context: context)
                        cat.id = UUID()
                        cat.name = randomCatName()
                        cat.age = Int16.random(in: 1...18)
                        cat.photoId = photoIds.randomElement()
                        cat.createdAt = Date()
                        cat.house = batchHouses.randomElement()!
                    }
                    try! context.save()
                    context.reset()
                }
                created += n
            }
            
            let time = CFAbsoluteTimeGetCurrent() - start
            DispatchQueue.main.async { completion(time) }
        }
    }

    // MARK: - randomizer
    private static let titles = ["Пан", "Сер", "Граф", "Барон", "Принц", "Капітан", "Доктор", "Лорд"]
    private static let names = ["Пельмень", "Барсик", "Кексик", "Мурчик", "Пушок", "Сирник", "Вареник",
                                "Бублик", "Тефтель", "Пиріжок", "Мармелад", "Пончик", "Сухарик", "Котлет"]
    private static let suffixes = ["Пухнастий", "Третій", "Молодший", "Сонний", "Грізний", "Величний", "Хитрий"]
    private static let houseNames = ["Котохата «Тепла Коробка»", "Котохата «Сонячне Підвіконня»",
                                     "Котохата «Мʼякий Плед»", "Котохата «Повна Миска»",
                                     "Котохата «Нічний Тигидик»", "Котохата «Котячий Рай»"]

    private static func randomCatName() -> String {
        "\(titles.randomElement()!) \(names.randomElement()!) \(suffixes.randomElement()!)"
    }
}
