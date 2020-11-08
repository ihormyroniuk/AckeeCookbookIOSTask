//
//  WebAPI.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 3/30/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

public protocol ApiInteractor {
    
    func getRecipes(offset: Int, limit: Int, completionHandler: @escaping (Result<[RecipeInList], ApiInteractionError>) -> ())
    func createNewRecipe(creatingRecipe: CreatingRecipe, completionHandler: @escaping (Result<RecipeInDetails, ApiInteractionError>) -> ())
    func getRecipe(recipeId: String, completionHandler: @escaping (Result<RecipeInDetails, ApiInteractionError>) -> ())
    func updateRecipe(updatingRecipe: UpdatingRecipe, completionHandler: @escaping (Result<RecipeInDetails, ApiInteractionError>) -> ())
    func deleteRecipe(recipeId: String, completionHandler: @escaping (ApiInteractionError?) -> ())
    func addNewRating(addingRating: AddingRating, completionHandler: @escaping (Result<AddedNewRating, ApiInteractionError>) -> ())
    
}
