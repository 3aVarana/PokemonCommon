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
    
    // MARK: - Helpers
    func makeSUT(url: URL = URL(string: "https://test-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemotePokemonLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemotePokemonLoader(url: url, client: client)
        return (sut, client)
    }
}
