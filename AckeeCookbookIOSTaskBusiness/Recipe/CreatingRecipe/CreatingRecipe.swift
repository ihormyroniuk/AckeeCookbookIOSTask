//
//  CreatingRecipe.swift
//  AckeeCookbookIOSTaskBusiness
//
//  Created by Ihor Myroniuk on 3/31/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

public protocol CreatingRecipe {
    var name: String { get }
    var description: String { get }
    var ingredients: [String] { get }
    var duration: Int { get }
    var info: String { get }
}
