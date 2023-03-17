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
    
    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://test-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemotePokemonLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemotePokemonLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func expect(_ sut: RemotePokemonLoader, toCompleteWith expectedResult: RemotePokemonLoader.Result, when action: () -> Void,
                        file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for loading completed")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.failure(receivedError as RemotePokemonLoader.Error), .failure(expectedError as RemotePokemonLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                print("BB")
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
            "results": items
        ] as [String : Any]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}
