//
//  DataGenerator.swift
//  pilat-molfar-io
//
//  Created by Eva Pilat on 19.11.2026.
//

import Foundation
import RealmSwift

enum DataGenerator {
    static func generate(count: Int = 100_000,
                         housesCount: Int = 500,
                         batchSize: Int = 10_000,
                         photoIds: [String],
                         completion: @escaping (TimeInterval) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let start = CFAbsoluteTimeGetCurrent()

            autoreleasepool {
                let realm = try! Realm()
                try! realm.write {
                    for _ in 0..<housesCount {
                        let house = CatHouse()
                        house.name = "\(houseNames.randomElement()!) №\(Int.random(in: 1...999))"
                        realm.add(house)
                    }
                }
            }

            var created = 0
            while created < count {
                let n = min(batchSize, count - created)
                autoreleasepool {
                    let realm = try! Realm()
                    let houses = Array(realm.objects(CatHouse.self))
                    try! realm.write {
                        for _ in 0..<n {
                            let cat = Cat()
                            cat.name = randomCatName()
                            cat.age = Int.random(in: 1...18)
                            cat.photoId = photoIds.randomElement()
                            houses.randomElement()!.cats.append(cat)
                        }
                    }
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
