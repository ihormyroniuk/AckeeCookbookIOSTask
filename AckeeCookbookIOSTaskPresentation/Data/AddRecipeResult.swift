//
//  AddRecipeResult.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 17.11.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

public enum AddRecipeResult {
    case addedRecipe(RecipeInDetails)
    case infoIsNeeded
    case descriptionIsNeeded
    case nameIsNeeded
    case nameMustContainsAckee
}
