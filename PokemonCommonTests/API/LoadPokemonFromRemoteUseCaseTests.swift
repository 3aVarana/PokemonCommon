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
    
    func test_load_requestFromUrlTwice() {
        let url = URL(string: "https://request-test-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let url = URL(string: "https://request-test-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        expect(sut, toCompleteWith: failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let url = URL(string: "https://request-test-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        let invalidCodes = [199, 201, 210, 300, 400, 500]
        
        invalidCodes.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData)) {
                let json = makeItemJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJson() {
        let url = URL(string: "https://request-test-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        expect(sut, toCompleteWith: failure(.invalidData)) {
            let invalidJSon = Data("Invalid JSON".utf8)
            client.complete(withStatusCode: 200, data: invalidJSon)
        }
    }
    
    func test_load_deliversNoPokemonON200HTTPResponseWithEmptyJsonList() {
        let url = URL(string: "https://request-test-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        expect(sut, toCompleteWith: .success([])) {
            let emptyJsonList = makeItemJSON([])
            client.complete(withStatusCode: 200, data: emptyJsonList)
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJsonListItems() {
        let url = URL(string: "https://request-test-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        let item1 = makeItem(id: 1,
                             name: "bulbasaur",
                             url: "https://pokeapi.co/api/v2/pokemon/1",
                             imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
        )
        
        let item2 = makeItem(id: 2,
                             name: "ivysaur",
                             url: "https://pokeapi.co/api/v2/pokemon/2",
                             imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/2.png"
        )
        
        expect(sut, toCompleteWith: .success([item1.model, item2.model])) {
            let jsonWithItems = makeItemJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: jsonWithItems)
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "https://request-test-url.com")!
        let client = HTTPClientSpy()
        var sut: RemotePokemonLoader? = RemotePokemonLoader(url: url, client: client)
        
        var receivedResults = [RemotePokemonLoader.Result]()
        
        sut?.load { receivedResults.append($0) }
        sut = nil
        
        client.complete(withStatusCode: 200, data: makeItemJSON([]))
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://test-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemotePokemonLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemotePokemonLoader(url: url, client: client)
        trackMemoryLeak(for: client, file: file, line: line)
        trackMemoryLeak(for: sut, file: file, line: line)
        return (sut, client)
    }
    
    private func expect(_ sut: RemotePokemonLoader, toCompleteWith expectedResult: RemotePokemonLoader.Result, when action: () -> Void,
                        file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for loading completed")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                
            case let (.failure(receivedError as RemotePokemonLoader.Error), .failure(expectedError as RemotePokemonLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    private func failure(_ error: RemotePokemonLoader.Error) -> RemotePokemonLoader.Result {
        return .failure(error)
    }
    
    private func makeItemJSON(_ items: [[String: Any]]) -> Data {
        let json = [
            "count": 100,
            "next": "",
            "previous": "",
            "result": items
        ] as [String : Any]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func makeItem(id: Int, name: String, url: String, imageUrl: String) -> (model: Pokemon, json: [String: Any]) {
        let typeItem1 = makeTypeItem(slot: 1, code: 10, name: "water")
        let typeItem2 = makeTypeItem(slot: 2, code: 11, name: "grass")
        
        let item = Pokemon(id: id, name: name, url: URL(string: url)!, imageUrl: URL(string: imageUrl)!, types: [typeItem1.model, typeItem2.model])
        
        let json = [
            "id": id,
            "name": name,
            "types": [
                typeItem1.json,
                typeItem2.json
            ]
        ].compactMapValues { $0 }
        
        return (item, json)
    }
    
    private func makeTypeItem(slot: Int, code: Int, name: String) -> (model: PokemonType, json: [String: Any]) {
        let item = PokemonType(slot: slot, code: code, name: name)
        
        let json = [
            "slot": slot,
            "code": code,
            "name": name
        ].compactMapValues { $0 }
        
        return (item, json)
    }
}
