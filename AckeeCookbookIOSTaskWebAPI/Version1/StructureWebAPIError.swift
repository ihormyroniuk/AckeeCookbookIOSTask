//
//  StructureWebAPIError.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 4/1/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

struct StructureWebAPIError: WebAPIError {
    let code: Int
    let name: String
}
