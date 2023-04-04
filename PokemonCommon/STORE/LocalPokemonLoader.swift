//
//  LocalPokemonLoader.swift
//  PokemonCommon
//
//  Created by Victor Arana on 4/3/23.
//

import Foundation

public final class LocalPokemonLoader {
    private let store: PokemonStore
    
    public init(store: PokemonStore) {
        self.store = store
    }
}
