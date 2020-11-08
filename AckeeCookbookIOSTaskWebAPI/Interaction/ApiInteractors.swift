//
//  ApiPerformerFactory.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 26.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation

public enum ApiInteractors {
    
    enum Host {
        static let mockServer = "private-anon-819a83e00e-cookbook3.apiary-mockh.com"
        static let debuggingProxy = "private-anon-819a83e00e-cookbook3.apiary-proxy.com"
        static let production = "cookbook.ack.ee"
    }
    
    public static var debuggingProxy: ApiInteractor {
        return ApiInteractorUrlSessionShared(version1Scheme: Uri.Scheme.https, version1Host: Host.debuggingProxy)
    }
    
    public static var mockServer: ApiInteractor {
        return ApiInteractorUrlSessionShared(version1Scheme: Uri.Scheme.https, version1Host: Host.mockServer)
    }
    
    public static var production: ApiInteractor {
        return ApiInteractorUrlSessionShared(version1Scheme: Uri.Scheme.https, version1Host: Host.production)
    }
    
}
