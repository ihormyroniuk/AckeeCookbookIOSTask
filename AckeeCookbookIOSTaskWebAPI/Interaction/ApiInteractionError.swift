//
//  ApiInteractionError.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 08.11.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

public enum ApiInteractionError: Error {
    case notConnectedToInternet
    case unexpectedError(error: Error)
}
