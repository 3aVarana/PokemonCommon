//
//  SavePokemonUseCaseTests.swift
//  PokemonCommonTests
//
//  Created by Victor Arana on 4/3/23.
//

import XCTest
import PokemonCommon

final class CachePokemonUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreOnCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        
        sut.save(uniquePokemonList()) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.delete])
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        sut.save(uniquePokemonList()) { _ in }
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.receivedMessages, [.delete])
    }
    
    func test_save_requestNewCacheInsertionOnSuccessfulDeletion() {
        let (sut, store) = makeSUT()
        let pokemonList = uniquePokemonList()
        
        sut.save(pokemonList) { _ in }
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.receivedMessages, [.delete, .insert(pokemonList)])
    }
    
    func test_save_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        expect(sut, toCompleteWithError: deletionError) {
            store.completeDeletion(with: deletionError)
        }
    }
    
    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        expect(sut, toCompleteWithError: insertionError) {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        }
    }
    
    func test_save_succeedsOnSuccessfulInsertion() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWithError: nil) {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        }
    }
    
    func test_save_doesNotDeliverDeletionAfterSUTInstanceHasBeenDeallocated() {
        let store = PokemonStoreSpy()
        var sut: LocalPokemonLoader? = LocalPokemonLoader(store: store)
        
        var receivedResults = [LocalPokemonLoader.SaveResult]()
        sut?.save(uniquePokemonList(), completion: {
            receivedResults.append($0)
        })
        
        sut = nil
        store.completeDeletionSuccessfully()
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    func test_store_doesNotDeliverInsertionAfterSUTInstanceHasBeenDeallocated() {
        let store = PokemonStoreSpy()
        var sut: LocalPokemonLoader? = LocalPokemonLoader(store: store)
        
        var receivedResults = [LocalPokemonLoader.SaveResult]()
        sut?.save(uniquePokemonList(), completion: {
            receivedResults.append($0)
        })
        
        store.completeDeletionSuccessfully()
        sut = nil
        store.completeInsertionSuccessfully()
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalPokemonLoader, store: PokemonStoreSpy) {
        let store = PokemonStoreSpy()
        let sut = LocalPokemonLoader(store: store)
        trackMemoryLeak(for: sut)
        trackMemoryLeak(for: store)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalPokemonLoader, toCompleteWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for save completion")
        
        var receivedError: Error?
        sut.save(uniquePokemonList()) { result in
            if case let .failure(error) = result {
                receivedError = error
            }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }
}
