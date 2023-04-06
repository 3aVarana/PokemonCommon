//
//  XCTestCase+TrackMemoryLeaks.swift
//  PokemonCommonTests
//
//  Created by Victor Arana on 3/17/23.
//

import XCTest

extension XCTestCase {
    func trackMemoryLeak(for instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. It's a potential memory leak", file: file, line: line)
        }
    }
}
