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
            XCTAssertEqual(pokemonList.count, 12, "Expected 12 Pokemon in the list for the the account")
            XCTAssertEqual(pokemonList[0], expectedPokemon(at: 0))
            XCTAssertEqual(pokemonList[1], expectedPokemon(at: 1))
            XCTAssertEqual(pokemonList[2], expectedPokemon(at: 2))
            XCTAssertEqual(pokemonList[3], expectedPokemon(at: 3))
            XCTAssertEqual(pokemonList[4], expectedPokemon(at: 4))
            XCTAssertEqual(pokemonList[5], expectedPokemon(at: 5))
            XCTAssertEqual(pokemonList[6], expectedPokemon(at: 6))
            XCTAssertEqual(pokemonList[7], expectedPokemon(at: 7))
        case let .failure(error)?:
            XCTFail("Expected successful Pokemon list, got \(error) instead")
        default:
            XCTFail("Expectes successful Pokemon list, got no result instead")
        }
        
    }
    
    // MARK: - Helpers
    
    private func getResult(file: StaticString = #file, line: UInt = #line) -> RemotePokemonLoader.Result? {
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
    
    private func expectedPokemon(at index: Int) -> Pokemon {
        return Pokemon(id: id(at: index),
                       name: name(at: index),
                       url: url(at: index),
                       imageUrl: imageURL(at: index),
                       types: types(at: index))
    }
    
    private func id(at index: Int) -> Int {
        return index + 1
    }
    
    
    private func name(at index: Int) -> String {
        return [
            "bulbasaur",
            "ivysaur",
            "venusaur",
            "charmander",
            "charmaleon",
            "charizard",
            "squirtle",
            "wartortle",
            "blastoise",
            "caterpie",
            "metapod",
            "butterfree",
        ][index]
    }
    
    private func url(at index: Int) -> URL {
        return URL(string: "https://pokeapi.co/api/v2/pokemon/\(index+1)")!
    }
    
    private func imageURL(at index: Int) -> URL {
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(index+1).png")!
    }
    
    private func types(at index: Int) -> [PokemonType] {
        return [[PokemonType(slot: 1, code: 12, name: "grass"),
                 PokemonType(slot: 2, code: 4, name: "poison")],
                [PokemonType(slot: 1, code: 12, name: "grass"),
                 PokemonType(slot: 2, code: 4, name: "poison")],
                [PokemonType(slot: 1, code: 12, name: "grass"),
                 PokemonType(slot: 2, code: 4, name: "poison")],
                
                [PokemonType(slot: 1, code: 10, name: "fire")],
                [PokemonType(slot: 1, code: 10, name: "fire")],
                [PokemonType(slot: 1, code: 10, name: "fire"),
                 PokemonType(slot: 2, code: 3, name: "flying")],
                
                [PokemonType(slot: 1, code: 11, name: "water")],
                [PokemonType(slot: 1, code: 11, name: "water")],
                [PokemonType(slot: 1, code: 11, name: "water")],
                
                [PokemonType(slot: 1, code: 7, name: "bug")],
                [PokemonType(slot: 1, code: 7, name: "bug")],
                [PokemonType(slot: 1, code: 7, name: "bug"),
                 PokemonType(slot: 2, code: 3, name: "flying")]][index]
    }

}
