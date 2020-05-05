//
//  StructureWebAPIError.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 4/1/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

struct WebApiVersion1ErrorStructure: WebApiVersion1Error {
    let code: Int
    let status: Int
    let name: String
}
