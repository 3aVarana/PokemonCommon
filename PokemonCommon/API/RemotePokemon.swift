//
//  RemotePokemon.swift
//  PokemonCommon
//
//  Created by Victor Arana on 3/14/23.
//

import Foundation

class RemotePokemon: Decodable {
    public let id: String
    public let name: String
    public let url: URL
    
    public init(id: String, name: String, url: URL) {
        self.id = id
        self.name = name
        self.url = url
    }
}
