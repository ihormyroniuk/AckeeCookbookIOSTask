//
//  UpdatingRecipe.swift
//  AckeeCookbookIOSTaskBusiness
//
//  Created by Ihor Myroniuk on 26.04.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

public protocol UpdatingRecipe {
    var id: String { get }
    var name: String { get }
    var duration: Int { get }
    var description: String { get }
    var info: String { get }
    var ingredients: [String] { get }
}
