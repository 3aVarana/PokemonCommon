//
//  FeedStoreSpy.swift
//  PokemonCommonTests
//
//  Created by Victor Arana on 4/3/23.
//

import Foundation
import PokemonCommon

class PokemonStoreSpy: PokemonStore {
    
    enum ReceivedMessage: Equatable {
        case delete
        case insert([Pokemon])
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var deleteCompletions = [DeletionCompletion]()
    private var insertionCompletions = [InsertionCompletion]()
    private var retrievalCompletions = [RetrievalCompletion]()
    
    func deleteCachedPokemon(completion: @escaping DeletionCompletion) {
        deleteCompletions.append(completion)
        receivedMessages.append(.delete)
    }
    
    func completeDeletion(with error: NSError, at index: Int = 0) {
        deleteCompletions[index](.failure(error))
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deleteCompletions[index](.success(()))
    }
    
    func insert(_ pokemonList: [PokemonCommon.Pokemon], completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
        receivedMessages.append(.insert(pokemonList))
    }
    
    func completeInsertion(with error: NSError, at index: Int = 0) {
        insertionCompletions[index](.failure(error))
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](.success(()))
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        retrievalCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }
    
    func completeRetrival(with error: NSError, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
}
