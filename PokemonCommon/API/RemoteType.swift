//
//  RemoteType.swift
//  PokemonCommon
//
//  Created by Victor Arana on 4/3/23.
//

import Foundation

public struct RemoteType: Decodable {
    public let slot: Int
    public let code: Int
    public let name: String
}
