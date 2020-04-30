//
//  UpdatingRecipeStructure.swift
//  AckeeCookbookIOSTaskBusiness
//
//  Created by Ihor Myroniuk on 26.04.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

public struct UpdatingRecipeStructure: UpdatingRecipe {
    public let id: String
    public let name: String
    public let duration: UInt
    public let description: String
    public let info: String
    public let ingredients: [String]

    public init(id: String, name: String, duration: UInt, description: String, info: String, ingredients: [String]) {
        self.id = id
        self.name = name
        self.duration = duration
        self.description = description
        self.info = info
        self.ingredients = ingredients
    }
}
