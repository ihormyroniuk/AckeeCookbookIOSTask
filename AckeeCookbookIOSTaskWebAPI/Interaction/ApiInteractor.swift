//
//  WebAPI.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 3/30/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation
import AckeeCookbookIOSTaskBusiness

public protocol ApiInteractor {
    func getRecipes(offset: Int, limit: Int, completionHandler: @escaping (Result<[RecipeInList], ApiInteractionError>) -> ())
    func createNewRecipe(_ recipe: CreatingRecipe, completionHandler: @escaping (Result<RecipeInDetails, ApiInteractionError>) -> ())
    func getRecipe(_ recipeId: String, completionHandler: @escaping (Result<RecipeInDetails, ApiInteractionError>) -> ())
    func updateRecipe(_ recipe: UpdatingRecipe, completionHandler: @escaping (Result<RecipeInDetails, ApiInteractionError>) -> ())
    func deleteRecipe(_ recipeId: String, completionHandler: @escaping (ApiInteractionError?) -> ())
    func addNewRating(_ recipeId: String, score: Float, completionHandler: @escaping (Result<AddedNewRating, ApiInteractionError>) -> ())
}
