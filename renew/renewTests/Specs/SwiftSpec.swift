//
//  SwiftSpec.swift
//  renewTests
//
//  Created by younghacker on 3/16/18.
//  Copyright © 2018 toureek. All rights reserved.
//

import Foundation
import Nimble
import Quick


// Without this, the Swift stdlib won't be linked into the test target (even if
// “Embedded Content Contains Swift Code” is enabled).
class SwiftSpec: QuickSpec {
    override func spec() {
        expect(true).to(beTruthy())
    }
}

