//
//  ApiPerformerFactory.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 26.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation

public enum ApiPerformerFactory {
    
    public static var productionApiPerformer: ApiPerformer {
        return ApiPerformerUrlSessionShared(version1Scheme: Uri.Scheme.https, version1Host: Api.Host.production)
    }
    
}
