//
//  ApiVersion1.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

enum Api {
    
    enum Scheme {
        static let https = "https"
    }
    
    enum Host {
        static let mockServer = "private-anon-819a83e00e-cookbook3.apiary-mockh.com"
        static let debuggingProxy = "private-anon-819a83e00e-cookbook3.apiary-proxy.com"
        static let production = "cookbook.ack.ee"
    }
    
    enum StatusCode {
        static let ok = 200
        static let noContent = 204
    }
    
    enum Method {
        static let get = "GET"
        static let post = "POST"
        static let put = "PUT"
        static let delete = "DELETE"
    }
    
    enum Header {
        static let contentType = "Content-Type"
        static let contentTypeJson = "application/json"
    }
    
}
