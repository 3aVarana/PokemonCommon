//
//  CoreDataPokemonStore.swift
//  PokemonCommon
//
//  Created by Victor Arana on 4/13/23.
//

import Foundation
import CoreData

public final class CoreDataPokemonStore: PokemonStore {
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        self.container = try NSPersistentContainer.load(modelName: "PokemonCD", url: storeURL, in: bundle)
        self.context = container.newBackgroundContext()
    }
    
    public func deleteCachedPokemon(completion: @escaping DeletionCompletion) {
        
    }
    
    public func insert(_ pokemonList: [Pokemon], completion: @escaping InsertionCompletion) {
        
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        
    }
    
}
