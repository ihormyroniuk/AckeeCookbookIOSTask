//
//  ApiPerformerFactory.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 26.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

public enum ApiPerformerFactory {
    
    public static var mockServerApiPerformer: ApiPerformer {
        return ApiPerformerUrlSessionShared(version1Scheme: Api.Scheme.https, version1Host: Api.Host.mockServer)
    }
    
    public static var debuggingProxyApiPerformer: ApiPerformer {
        return ApiPerformerUrlSessionShared(version1Scheme: Api.Scheme.https, version1Host: Api.Host.debuggingProxy)
    }
    
    public static var productionApiPerformer: ApiPerformer {
        return ApiPerformerUrlSessionShared(version1Scheme: Api.Scheme.https, version1Host: Api.Host.production)
    }
    
}
