//
//  PokemonErrorViewModel.swift
//  Pokemon iOS
//
//  Created by Victor Arana on 4/13/23.
//

import Foundation

public struct PokemonErrorViewModel {
    public let message: String?
    
    public init(message: String?) {
        self.message = message
    }
    
    public static var noError: PokemonErrorViewModel {
        return PokemonErrorViewModel(message: nil)
    }
    
    public static func error(message: String) -> PokemonErrorViewModel {
        return PokemonErrorViewModel(message: message)
    }
}
