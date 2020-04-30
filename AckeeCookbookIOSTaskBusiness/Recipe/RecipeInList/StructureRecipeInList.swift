//
//  StructureRecipeInList.swift
//  AckeeCookbookIOSTaskBusiness
//
//  Created by Ihor Myroniuk on 3/26/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

public struct StructureRecipeInList: RecipeInList {
    public let id: String
    public let name: String
    public let duration: UInt
    public var score: Float

    public init(id: String, name: String, duration: UInt, score: Float) {
        self.id = id
        self.name = name
        self.duration = duration
        self.score = score
    }
}
