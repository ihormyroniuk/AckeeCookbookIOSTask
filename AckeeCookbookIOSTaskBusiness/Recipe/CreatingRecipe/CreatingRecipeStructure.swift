//
//  StructureCreatingRecipe.swift
//  AckeeCookbookIOSTaskBusiness
//
//  Created by Ihor Myroniuk on 3/31/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

public struct CreatingRecipeStructure: CreatingRecipe {
    public let name: String
    public let description: String
    public let ingredients: [String]
    public let duration: UInt
    public let info: String

    public init(name: String, description: String, ingredients: [String], duration: UInt, info: String) {
        self.name = name
        self.description = description
        self.ingredients = ingredients
        self.duration = duration
        self.info = info
    }
}
