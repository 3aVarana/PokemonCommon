//
//  HTTPURLResponse+statusCode.swift
//  PokemonCommon
//
//  Created by Victor Arana on 3/14/23.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }
    
    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
