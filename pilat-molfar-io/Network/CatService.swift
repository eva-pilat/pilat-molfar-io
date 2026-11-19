//
//  CatService.swift
//  pilat-molfar-io
//
//  Created by Eva Pilat on 19.11.2026.
//

import Foundation

private struct CataasCat: Decodable {
    let id: String
    enum CodingKeys: String, CodingKey { case id, _id }
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decodeIfPresent(String.self, forKey: .id)
            ?? c.decode(String.self, forKey: ._id)
    }
}

enum CatPhotoService {
    static func fetchPhotoIds(limit: Int = 100) async -> [String] {
        let skip = Int.random(in: 0...2000)
        guard let url = URL(string: "https://cataas.com/api/cats?limit=\(limit)&skip=\(skip)") else { return [] }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode([CataasCat].self, from: data).map(\.id)
        } catch {
            print("CATAAS error: \(error)")
            return []
        }
    }

    static func imageURL(for id: String?) -> URL? {
        guard let id else { return nil }
        return URL(string: "https://cataas.com/cat/\(id)?width=200&height=200")
    }
}
