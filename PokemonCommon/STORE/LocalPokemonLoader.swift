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
        store.deleteCachedPokemon { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.cache(pokemonList, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func cache(_ pokemonList: [Pokemon], completion: @escaping (SaveResult) -> Void) {
        store.insert(pokemonList) { [weak self] insertionResult in
            guard self != nil else { return }
            completion(insertionResult)
        }
    }
}

extension LocalPokemonLoader: PokemonLoader {
    public typealias LoadResult = PokemonLoader.Result
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve(completion: completion)
    }
    
}
