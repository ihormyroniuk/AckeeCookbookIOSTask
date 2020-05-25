//
//  StructureRecipeInList.swift
//  AckeeCookbookIOSTaskBusiness
//
//  Created by Ihor Myroniuk on 3/26/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

public struct RecipeInListStructure: RecipeInList {
    public let id: String
    public let name: String
    public let duration: Int
    public var score: Float

    public init(id: String, name: String, duration: Int, score: Float) {
        self.id = id
        self.name = name
        self.duration = duration
        self.score = score
    }
}
