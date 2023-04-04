//
//  ManagedPokemon.swift
//  PokemonCommon
//
//  Created by Victor Arana on 4/3/23.
//

import CoreData

@objc(ManagedPokemon)
class ManagedPokemon: NSManagedObject {
    @NSManaged var id: Int32
    @NSManaged var name: String
    @NSManaged var dataUrl: URL
    @NSManaged var imageUrl: URL
    @NSManaged var types: NSOrderedSet
}
