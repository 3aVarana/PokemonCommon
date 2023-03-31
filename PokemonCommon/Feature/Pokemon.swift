//
//  Pokemon.swift
//  PokemonCommon
//
//  Created by Victor Arana on 3/14/23.
//

import Foundation

public struct PokemonType: Equatable {
    public let slot: Int
    public let code: Int
    public let name: String
}

public struct Pokemon: Equatable {
    
    public let id: Int
    public let name: String
    public let url: URL
    public let imageUrl: URL
    public let types: [PokemonType]
}
