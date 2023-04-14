//
//  PokemonImageViewModel.swift
//  Pokemon iOS
//
//  Created by Victor Arana on 4/13/23.
//

import PokemonCommon

public struct PokemonViewModel<Image> {
    public let id: Int
    public let name: String
    public let image: Image?
    public let isLoading: Bool
    public let shouldRetry: Bool
    public let types: [PokemonType]
    
    public init(id: Int, name: String, image: Image?, isLoading: Bool, shouldRetry: Bool, types: [PokemonType]) {
        self.id = id
        self.name = name
        self.image = image
        self.isLoading = isLoading
        self.shouldRetry = shouldRetry
        self.types = types
    }
}
