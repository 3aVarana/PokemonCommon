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
        perform { context in
            completion(Result {
                try ManagedPokemon.find(in: context).map(context.delete).map(context.save)
            })
        }
    }
    
    public func insert(_ pokemonList: [Pokemon], completion: @escaping InsertionCompletion) {
        perform { context in
            completion(Result {
                let _ = try pokemonList.map { pokemon in
                    let managedPokemon = try ManagedPokemon.newUniqueInstance(in: context)
                    managedPokemon.id = Int32(pokemon.id)
                    managedPokemon.name = pokemon.name
                    managedPokemon.dataUrl = pokemon.url
                    managedPokemon.imageUrl = pokemon.imageUrl
                    managedPokemon.types = ManagedType.types(from: pokemon.types, in: context)
                    return managedPokemon
                }
                try context.save()
            })
        }
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            completion(Result {
                try ManagedPokemon.find(in: context).map{
                    return Pokemon(id: Int($0.id),
                                   name: $0.name,
                                   url: $0.dataUrl,
                                   imageUrl: $0.imageUrl,
                                   types: $0.localTypes)
                }
            })
        }
    }
    
    private func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
    
}
