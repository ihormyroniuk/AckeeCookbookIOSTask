//
//  ApiVersion1.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

class Api {
    
    enum Host {
        static let mockServer = "private-anon-819a83e00e-cookbook3.apiary-mockh.com"
        static let debuggingProxy = "private-anon-819a83e00e-cookbook3.apiary-proxy.com"
        static let production = "cookbook.ack.ee"
    }
    
    private let scheme: String
    private let host: String
    let version1: ApiVersion1
    
    public init(scheme: String, host: String) {
        self.scheme = scheme
        self.host = host
        let version1 = ApiVersion1(scheme: scheme, host: host)
        self.version1 = version1
    }
    
}
