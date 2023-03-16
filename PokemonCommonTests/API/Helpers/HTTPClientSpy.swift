//
//  HTTPClientSpy.swift
//  PokemonCommonTests
//
//  Created by Victor Arana on 3/15/23.
//

import Foundation
import PokemonCommon

private struct HTTPClientSpyTask: HTTPClientTask {
    func cancel() {}
}

class HTTPClientSpy: HTTPClient {
    
    private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
    
    var requestedURLs: [URL] {
        messages.map { $0.url }
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        messages.append((url, completion))
        return HTTPClientSpyTask()
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
}
