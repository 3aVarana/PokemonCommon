//
//  PokemonCache.swift
//  PokemonCommon
//
//  Created by Victor Arana on 4/13/23.
//

import Foundation

public protocol PokemonCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ feed: [Pokemon], completion: @escaping (Result) -> Void)
}
