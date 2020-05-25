//
//  AddedNewRating.swift
//  AckeeCookbookIOSTaskBusiness
//
//  Created by Ihor Myroniuk on 06.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

public struct AddedNewRating {
    public let id: String
    public let recipeId: String
    public let score: Float
    
    public init(id: String, recipeId: String, score: Float) {
        self.id = id
        self.recipeId = recipeId
        self.score = score
    }
}
