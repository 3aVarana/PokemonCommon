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
}
