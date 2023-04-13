//
//  PokemonCacheIntegrationTests.swift
//  PokemonCacheIntegrationTests
//
//  Created by Victor Arana on 4/13/23.
//

import XCTest
import PokemonCommon

final class PokemonCacheIntegrationTests: XCTestCase {

    func test_deliver_noItemsOnEmptyCache() {
        let sut = makeSUT()
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> LocalPokemonLoader {
        let bundle = Bundle(for: CoreDataPokemonStore.self)
        let storeURL = getSpeficicTestStoreURL()
        let store = try! CoreDataPokemonStore(storeURL: storeURL, bundle: bundle)
        let loader = LocalPokemonLoader(store: store)
        
        trackMemoryLeak(for: store, file: file, line: line)
        trackMemoryLeak(for: loader, file: file, line: line)
        
        return loader
    }
    
    private func expect(_ sut: LocalPokemonLoader, toLoad expectedPokemonList: [Pokemon], file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { result in
            switch result {
            case let .success(receivedPokemonList):
                XCTAssertEqual(receivedPokemonList, expectedPokemonList, file: file, line: line)
            case let .failure(error):
                XCTFail("Expected successful result, got \(error) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func getSpeficicTestStoreURL() -> URL {
        return cacheDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cacheDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }

}
