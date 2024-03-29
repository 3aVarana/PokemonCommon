//
//  PokemonStore.swift
//  PokemonCommon
//
//  Created by Victor Arana on 4/3/23.
//

import Foundation

public protocol PokemonStore {
    typealias DeletionResult = Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    typealias InsertionResult = Result<Void, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias RetrievalResult = Result<[Pokemon], Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    func deleteCachedPokemon(completion: @escaping DeletionCompletion)
    
    func insert(_ pokemonList: [Pokemon], completion: @escaping InsertionCompletion)
    
    func retrieve(completion: @escaping RetrievalCompletion)
}
