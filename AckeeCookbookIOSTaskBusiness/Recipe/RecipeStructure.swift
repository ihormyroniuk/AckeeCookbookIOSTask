//
//  RecipeStructure.swift
//  AckeeCookbookIOSTaskBusiness
//
//  Created by Ihor Myroniuk on 3/31/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

public struct RecipeStructure: Recipe {
    public let id: String
    public let name: String
    public let duration: UInt
    public let description: String
    public let info: String
    public let ingredients: [String]
    public let score: Float

    public init(id: String, name: String, duration: UInt, description: String, info: String, ingredients: [String], score: Float) {
        self.id = id
        self.name = name
        self.duration = duration
        self.description = description
        self.info = info
        self.ingredients = ingredients
        self.score = score
    }
}
