//
//  ManagedPokemon.swift
//  PokemonCommon
//
//  Created by Victor Arana on 4/3/23.
//

import CoreData

@objc(ManagedPokemon)
public class ManagedPokemon: NSManagedObject {
    @NSManaged var id: Int32
    @NSManaged var name: String
    @NSManaged var dataUrl: URL
    @NSManaged var imageUrl: URL
    @NSManaged var types: NSOrderedSet
}

extension ManagedPokemon {
    static func find(in context: NSManagedObjectContext) throws -> [ManagedPokemon] {
        let request = NSFetchRequest<ManagedPokemon>(entityName: entity().name!)
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        request.returnsObjectsAsFaults = false
        return try context.fetch(request)
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedPokemon {
        return ManagedPokemon(context: context)
    }
    
    var localTypes: [PokemonType] {
        return types.compactMap { ($0 as? ManagedType)?.local }
    }
}
