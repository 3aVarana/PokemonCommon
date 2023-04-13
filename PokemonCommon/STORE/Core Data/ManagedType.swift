//
//  ManagedType.swift
//  PokemonCommon
//
//  Created by Victor Arana on 4/3/23.
//

import CoreData

@objc(ManagedType)
class ManagedType: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var slot: Int32
    @NSManaged var code: Int32
    @NSManaged var name: String
}

extension ManagedType {
    static func types(from localTypes: [PokemonType], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localTypes.map { local in
            let managed = ManagedType(context: context)
            managed.slot = Int32(local.slot)
            managed.code = Int32(local.code)
            managed.name = local.name
            return managed
        })
    }
    
    var local: PokemonType {
        return PokemonType(slot: Int(slot), code: Int(code), name: name)
    }
}
