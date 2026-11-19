//
//  Cat.swift
//  pilat-molfar-io
//
//  Created by Eva Pilat on 19.11.2026.
//

import RealmSwift

final class Cat: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted(indexed: true) var name: String = ""
    @Persisted var age: Int = 0
    @Persisted var photoId: String?
    @Persisted(originProperty: "cats")
    var house: LinkingObjects<CatHouse>
}
