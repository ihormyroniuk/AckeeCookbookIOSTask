//
//  WebAPI.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 3/30/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation
import AckeeCookbookIOSTaskBusiness

public enum GetRecipesListResult {
    case recipesList([RecipeInList])
    case error(Error)
}

public enum CreateRecipeResult {
    case createdRecipe(Recipe)
    case error(Error)
}

public protocol WebAPI {
    func getRecipesList(offset: UInt, limit: UInt, completionHandler: @escaping (GetRecipesListResult) -> ())
    func createRecipe(_ recipe: CreatingRecipe, completionHandler: @escaping (CreateRecipeResult) -> ())
}
