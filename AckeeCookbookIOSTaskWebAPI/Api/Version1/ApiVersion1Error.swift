//
//  ApiVersion1Error.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 04.11.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

struct ApiVersion1Error: Error, LocalizedError {
    
    let code: Int
    let status: Int
    let name: String
    let message: String
    
    var errorDescription: String? {
        return message
    }

}
