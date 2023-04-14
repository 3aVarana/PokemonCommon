//
//  PokemonCacheIntegrationTests.swift
//  PokemonCacheIntegrationTests
//
//  Created by Victor Arana on 4/13/23.
//

import XCTest
import PokemonCommon

final class PokemonCacheIntegrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        deleteStoreSideEffects()
    }

    func test_load_deliversNoItemsOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toLoad: [])
    }
    
    func test_load_deliversItemsSavedPreviouslyByAnotherInstace() {
        let sutToPerformSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        
        let pokemonList = uniquePokemonList()
        
        
        save(pokemonList, with: sutToPerformSave)
        expect(sutToPerformLoad, toLoad: pokemonList)
    }
    
    func test_load_overridesItemsSavedPreviouslyByAnotherInstance() {
        let sutToPerformFirstSave = makeSUT()
        let sutToPerformSecondSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        
        let firstPokemonList = uniquePokemonList()
        let secondPokemonList = uniquePokemonList(addExtra: true)
        
        save(firstPokemonList, with: sutToPerformFirstSave)
        save(secondPokemonList, with: sutToPerformSecondSave)
        
        expect(sutToPerformLoad, toLoad: secondPokemonList)
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
    
    private func save(_ pokemonList: [Pokemon], with sut: LocalPokemonLoader, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for save completion")
        
        sut.save(pokemonList) { result in
            if case let Result.failure(error) = result {
                XCTFail("Expected to save successfully, got \(error) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
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
    
    func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    func deleteStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: getSpeficicTestStoreURL())
    }
    
    private func getSpeficicTestStoreURL() -> URL {
        return cacheDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cacheDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }

}
