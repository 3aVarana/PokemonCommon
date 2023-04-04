//
//  RemotePokemon.swift
//  PokemonCommon
//
//  Created by Victor Arana on 3/14/23.
//

import Foundation

public struct RemotePokemon: Decodable {
    
    public let id: Int
    public let name: String
    public let types: [RemoteType]
    
    public func getUrl() -> URL {
        return URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)")!
    }
    
    public func getImageUrl() -> URL {
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")!
    }
}
