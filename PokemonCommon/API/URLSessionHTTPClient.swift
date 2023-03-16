//
//  URLSessionHTTPClient.swift
//  PokemonCommon
//
//  Created by Victor Arana on 3/14/23.
//

import Foundation

private struct URLSessionTaskWrapper: HTTPClientTask {
    let wrapper: URLSessionDataTask
    
    func cancel() {
        wrapper.cancel()
    }
}

private class UnexpectedValuesError: Error {}

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: url) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesError()
                }
            })
        }
        return URLSessionTaskWrapper(wrapper: task)
    }
}
