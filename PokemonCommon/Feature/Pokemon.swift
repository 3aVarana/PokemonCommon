//
//  Pokemon.swift
//  PokemonCommon
//
//  Created by Victor Arana on 3/14/23.
//

import Foundation

public class Pokemon {
    public let id: String
    public let name: String
    public let url: URL
    
    init(id: String, name: String, url: URL) {
        self.id = id
        self.name = name
        self.url = url
    }
}
