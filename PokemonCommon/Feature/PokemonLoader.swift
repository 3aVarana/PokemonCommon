//
//  PokemonLoader.swift
//  PokemonCommon
//
//  Created by Victor Arana on 3/14/23.
//

import Foundation

public protocol PokemonLoader {
    typealias Result = Swift.Result<[Pokemon], Error>

    func load(completion: @escaping (Result) -> Void)
}
