//
//  CatHouse.swift
//  pilat-molfar-io
//
//  Created by Eva Pilat on 19.11.2026.
//

import RealmSwift

final class CatHouse: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var cats: List<Cat>
}
