//
//  FeedStoreSpy.swift
//  PokemonCommonTests
//
//  Created by Victor Arana on 4/3/23.
//

import Foundation
import PokemonCommon

class PokemonStoreSpy: PokemonStore {
    enum ReceivedMessage: Equatable {
        case delete
        case insert([Pokemon])
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
}
