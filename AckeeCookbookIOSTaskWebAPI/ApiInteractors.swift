//
//  ApiPerformerFactory.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 26.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation

public enum ApiInteractors {
    
    public static var production: ApiInteractor {
        return ApiInteractorUrlSessionShared(version1Scheme: Uri.Scheme.https, version1Host: Api.Host.production)
    }
    
}
