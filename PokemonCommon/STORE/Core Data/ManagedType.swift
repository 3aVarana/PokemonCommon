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
