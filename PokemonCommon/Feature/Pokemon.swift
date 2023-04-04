//
//  Pokemon.swift
//  PokemonCommon
//
//  Created by Victor Arana on 3/14/23.
//

import Foundation

public struct Pokemon: Equatable {
    
    public let id: Int
    public let name: String
    public let url: URL
    public let imageUrl: URL
    public let types: [PokemonType]
    
    public init(id: Int, name: String, url: URL, imageUrl: URL, types: [PokemonType]) {
        self.id = id
        self.name = name
        self.url = url
        self.imageUrl = imageUrl
        self.types = types
    }
}
