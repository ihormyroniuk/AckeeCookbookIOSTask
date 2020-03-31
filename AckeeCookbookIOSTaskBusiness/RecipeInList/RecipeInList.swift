//
//  ReceipeInList.swift
//  AckeeCookbookIOSTaskBusiness
//
//  Created by Ihor Myroniuk on 3/26/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

public protocol RecipeInList {
    var id: String { get }
    var name: String { get }
    var duration: UInt { get }
    var score: Float { get }
}
