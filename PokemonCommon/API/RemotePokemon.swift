//
//  RemotePokemon.swift
//  PokemonCommon
//
//  Created by Victor Arana on 3/14/23.
//

import Foundation

class RemotePokemon: Decodable {
    public let name: String
    public let url: String
    
    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
    
    public func getIdentifier() -> String {
        let components = url.split(separator: "/")
        guard let id = components.last else {
            return "1"
        }
        return String(id)
    }
    
    public func getImageUrl() -> URL {
        let id = getIdentifier()
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")!
    }
}
