//
//  PokemonCommonEndToEndAPITests.swift
//  PokemonCommonEndToEndAPITests
//
//  Created by Victor Arana on 4/13/23.
//

import XCTest
import PokemonCommon

final class PokemonCommonEndToEndAPITests: XCTestCase {

    func test_endToEndServerGETResult_matchesFixedTestAccountData() {
        let result = getResult()
        switch result {
        case let .success(pokemonList)?:
            XCTAssertEqual(pokemonList.count, 12)
        case let .failure(error)?:
            XCTFail("Expected successful Pokemon list, got \(error) instead")
        default:
            XCTFail("Expectes successful Pokemon list, got no result instead")
        }
        
    }
    
    func getResult(file: StaticString = #file, line: UInt = #line) -> RemotePokemonLoader.Result? {
        let testServerURL = URL(string: "https://stoplight.io/mocks/pokedex/pokeapi/158224127/pokemon")!
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let loader = RemotePokemonLoader(url: testServerURL, client: client)
        
        trackMemoryLeak(for: client, file: file, line: line)
        trackMemoryLeak(for: loader, file: file, line: line)
        
        let exp = expectation(description: "Wait for loading completion")
        
        var receivedResult: RemotePokemonLoader.Result?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
        
        return receivedResult
    }

}
