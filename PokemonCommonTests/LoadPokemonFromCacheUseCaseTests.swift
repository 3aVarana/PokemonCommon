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
    
    func test_load_failsOnRetrivalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(retrievalError)) {
            store.completeRetrival(with: retrievalError)
        }
        
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalPokemonLoader, store: PokemonStoreSpy) {
        let store = PokemonStoreSpy()
        let sut = LocalPokemonLoader(store: store)
        trackMemoryLeak(for: sut)
        trackMemoryLeak(for: store)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalPokemonLoader, toCompleteWith expectedResult: LocalPokemonLoader.LoadResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for retrival completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError)
            default:
                XCTAssertTrue(false)
            }
            
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }

}
