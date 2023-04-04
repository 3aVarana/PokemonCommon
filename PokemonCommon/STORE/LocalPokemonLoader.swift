//
//  LocalPokemonLoader.swift
//  PokemonCommon
//
//  Created by Victor Arana on 4/3/23.
//

import Foundation

public final class LocalPokemonLoader {
    private let store: PokemonStore
    
    public init(store: PokemonStore) {
        self.store = store
    }
}

extension LocalPokemonLoader {
    public typealias SaveResult = Result<Void, Error>
    
    public func save(_ pokemonList: [Pokemon], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedPokemon(completion: completion)
    }
}
