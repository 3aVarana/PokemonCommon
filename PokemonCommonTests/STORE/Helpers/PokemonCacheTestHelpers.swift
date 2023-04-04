//
//  PokemonCacheTestHelpers.swift
//  PokemonCommonTests
//
//  Created by Victor Arana on 4/3/23.
//

import Foundation
import PokemonCommon

func anyUrl() -> URL {
    return URL(string: "https://pokemon.com")!
}
func uniqueType(slot: Int) -> PokemonType {
    return PokemonType(slot: slot, code: 2, name: "any")
}

func uniquePokemon(id: Int) -> Pokemon {
    return Pokemon(id: id, name: "poke", url: anyUrl(), imageUrl: anyUrl(), types: [uniqueType(slot: 1), uniqueType(slot: 2)])
}

func uniquePokemonList() -> [Pokemon] {
    var pokemonList = [Pokemon]()
    pokemonList.append(uniquePokemon(id: 1))
    pokemonList.append(uniquePokemon(id: 2))
    pokemonList.append(uniquePokemon(id: 3))
    return pokemonList
}
