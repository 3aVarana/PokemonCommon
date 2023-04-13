//
//  LoadPokemonFromCacheUseCaseTests.swift
//  PokemonCommonTests
//
//  Created by Victor Arana on 4/12/23.
//

import XCTest
import PokemonCommon

final class LoadPokemonFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotRequestRetrivalUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestCacheRetrivalUponLoading() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    // MARK: - Helpers
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalPokemonLoader, store: PokemonStoreSpy) {
        let store = PokemonStoreSpy()
        let sut = LocalPokemonLoader(store: store)
        trackMemoryLeak(for: sut)
        trackMemoryLeak(for: store)
        return (sut, store)
    }

}
