//
//  WebAPI.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 3/30/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation
import AckeeCookbookIOSTaskBusiness

public enum WebApiPerformerGetRecipesListResult {
    case recipesList([RecipeInList])
    case error(Error)
}

public enum WebApiPerformerCreateRecipeResult {
    case createdRecipe(RecipeInDetails)
    case error(Error)
}

public enum WebApiPerformerGetRecipeInDetailsResult {
    case recipeInDetails(RecipeInDetails)
    case error(Error)
}

public enum WebApiPerformerDeleteRecipeResult {
    case deleted
    case error(Error)
}

public enum WebApiPerformerUpdateRecipeResult {
    case updatedRecipe(RecipeInDetails)
    case error(Error)
}

public enum WebApiPerformerScoreRecipeResult {
    case recipeScore(Float)
    case error(Error)
}

public protocol WebApiPerformer {
    func getRecipesList(offset: UInt, limit: UInt, completionHandler: @escaping (WebApiPerformerGetRecipesListResult) -> ())
    func createRecipe(_ recipe: CreatingRecipe, completionHandler: @escaping (WebApiPerformerCreateRecipeResult) -> ())
    func getRecipeInDetails(_ recipeId: String, completionHandler: @escaping (WebApiPerformerGetRecipeInDetailsResult) -> ())
    func updateRecipe(_ recipe: UpdatingRecipe, completionHandler: @escaping (WebApiPerformerUpdateRecipeResult) -> ())
    func deleteRecipe(_ recipeId: String, completionHandler: @escaping (WebApiPerformerDeleteRecipeResult) -> ())
    func scoreRecipe(_ recipeId: String, score: Float, completionHandler: @escaping (WebApiPerformerScoreRecipeResult) -> ())
}
