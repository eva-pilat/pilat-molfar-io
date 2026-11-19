//
//  RealmConfig.swift
//  pilat-molfar-io
//
//  Created by Eva Pilat on 19.11.2026.
//

import RealmSwift

enum RealmConfig {
    static func setup() {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 1,
            deleteRealmIfMigrationNeeded: true
        )
    }
}
