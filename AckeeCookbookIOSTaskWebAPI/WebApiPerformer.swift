//
//  WebAPI.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 3/30/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation
import AckeeCookbookIOSTaskBusiness

public enum WebApiPerformerGetRecipesResult {
    case recipes([RecipeInList])
    case error(Error)
}

public enum WebApiPerformerCreateRecipeResult {
    case recipe(RecipeInDetails)
    case error(Error)
}

public enum WebApiPerformerGetRecipeResult {
    case recipe(RecipeInDetails)
    case error(Error)
}

public enum WebApiPerformerUpdateRecipeResult {
    case recipe(RecipeInDetails)
    case error(Error)
}

public enum WebApiPerformerDeleteRecipeResult {
    case deleted
    case error(Error)
}

public enum WebApiPerformerScoreRecipeResult {
    case score(Float)
    case error(Error)
}

public protocol WebApiPerformer {
    func getRecipes(offset: UInt, limit: UInt, completionHandler: @escaping (WebApiPerformerGetRecipesResult) -> ())
    func createRecipe(_ recipe: CreatingRecipe, completionHandler: @escaping (WebApiPerformerCreateRecipeResult) -> ())
    func getRecipe(_ recipeId: String, completionHandler: @escaping (WebApiPerformerGetRecipeResult) -> ())
    func updateRecipe(_ recipe: UpdatingRecipe, completionHandler: @escaping (WebApiPerformerUpdateRecipeResult) -> ())
    func deleteRecipe(_ recipeId: String, completionHandler: @escaping (WebApiPerformerDeleteRecipeResult) -> ())
    func scoreRecipe(_ recipeId: String, score: Float, completionHandler: @escaping (WebApiPerformerScoreRecipeResult) -> ())
}
