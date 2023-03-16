//
//  PokemonItemsMapper.swift
//  PokemonCommon
//
//  Created by Victor Arana on 3/14/23.
//

import Foundation

public final class PokemonItemsMapper {
    
    private struct Root: Decodable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [RemotePokemon]
    }
    
    static func map(_ data: Data, response: HTTPURLResponse) throws -> [RemotePokemon] {
        guard response.isOK, let items = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemotePokemonLoader.Error.invalidData
        }
        return items.results
    }
}
