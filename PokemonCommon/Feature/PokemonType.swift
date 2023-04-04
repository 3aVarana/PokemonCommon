//
//  PokemonType.swift
//  PokemonCommon
//
//  Created by Victor Arana on 4/3/23.
//

import Foundation

public struct PokemonType: Equatable {
    public let slot: Int
    public let code: Int
    public let name: String
    
    public init(slot: Int, code: Int, name: String) {
        self.slot = slot
        self.code = code
        self.name = name
    }
}
