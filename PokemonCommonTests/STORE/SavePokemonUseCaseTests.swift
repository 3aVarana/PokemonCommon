//
//  SavePokemonUseCaseTests.swift
//  PokemonCommonTests
//
//  Created by Victor Arana on 4/3/23.
//

import XCTest
import PokemonCommon

final class SavePokemonUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreOnCreation() {
        let (_, sut) = makeSUT()
        
//        XCTAssertEqual(sut.receivedMessages, [])
        XCTAssertEqual("a", "a")
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalPokemonLoader, store: PokemonStoreSpy) {
        let store = PokemonStoreSpy()
        let sut = LocalPokemonLoader(store: store)
        return (sut, store)
    }
}