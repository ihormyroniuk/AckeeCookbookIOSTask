//
//  WebAPIError.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 4/1/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

protocol WebAPIError: Error {
    var code: Int { get }
    var name: String { get }
}
