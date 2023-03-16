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
    public let imageUrl: URL
    
    public init(id: String, name: String, url: URL, imageUrl: URL) {
        self.id = id
        self.name = name
        self.url = url
        self.imageUrl = imageUrl
    }
}
