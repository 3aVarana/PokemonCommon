//
//  LoadPokemonFromRemoteUseCaseTests.swift
//  PokemonCommonTests
//
//  Created by Victor Arana on 3/15/23.
//

import XCTest
import PokemonCommon

final class LoadPokemonFromRemoteUseCaseTests: XCTestCase {

    func test_init_doesNotRequestDataFromUrl() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestDataFromUrl() {
        let url = URL(string: "https://request-test-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    // MARK: - Helpers
    func makeSUT(url: URL = URL(string: "https://test-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemotePokemonLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemotePokemonLoader(url: url, client: client)
        return (sut, client)
    }
}
