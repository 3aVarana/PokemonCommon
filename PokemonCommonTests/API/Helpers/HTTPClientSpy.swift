//
//  HTTPClientSpy.swift
//  PokemonCommonTests
//
//  Created by Victor Arana on 3/15/23.
//

import Foundation
import PokemonCommon

private class HTTPClientSpyTask: HTTPClientTask {
    func cancel() {}
}

class HTTPClientSpy: HTTPClient {
    
    var requestedURLs: [URL] = []
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        return HTTPClientSpyTask()
    }
    
}
