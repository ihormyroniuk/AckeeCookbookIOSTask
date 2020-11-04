//
//  ApiVersion1.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

enum Api {
    
    enum Host {
        static let mockServer = "private-anon-819a83e00e-cookbook3.apiary-mockh.com"
        static let debuggingProxy = "private-anon-819a83e00e-cookbook3.apiary-proxy.com"
        static let production = "cookbook.ack.ee"
    }
    
    enum StatusCode {
        static let ok = 200
        static let noContent = 204
    }
    
    enum Header {
        static let contentType = "Content-Type"
        static let contentTypeJson = "application/json"
    }
    
}
